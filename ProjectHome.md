Allows to save your data into ByteArray in multibyte order.
This project extends ByteArray functionality and brings compact data format based on data-maps. You can read and write data bit by bit and create maps by creating clusters of data registering objects and properties where data should be gathered or where data should be passed after reading data source. Main advantage is data linkages never stored, so you will have very compact ByteArray, but not having proper data-map you will not be able to read stored data. So you can construct custom packets of data to read and write.

Core of the Multibyte project are classes MultibyteReader and MultibyteWriter, extending ByteArray functionality allow to read single bits or any amount of data between bytes.
```
var bool:Boolean = true;
var integer:int = -12;
var unsigned:uint = 342;
var float:Number = 46.5;
```
Let's write this data in multibyte order:
```
var writer:MultibyteWriter = new MultibyteWriter();
writer.writeBoolean(bool); //  1 bit
writer.write(integer, 6); //  6 bits
writer.write(unsigned, 9, false); //  9 bits
writer.writeCustomFloat(float, 16, 6); //  16 bits
writer.fill(); // write bits if something left  out of last byte written
```
So, here in total we used 32 bits or 4 bytes to store this information.  Methods readCustomFloat/writeCustomFloat methods allow you to configure bits count for your own IEEE-754 numbers and if you do not want high precision, you can spend less bits to store value.
Here are bits we have written:

11101001 | 01010110 | 01001000 | 11101000

First bit is our boolean value. Normal boolean stored with ByteArray.writeBoolean() will take a byte, 8 bits.

Next 6 bits are signed integer value -12, but its sawed in two's complement format.

110100

Let's normalize

001011 – revert bit values

001100 – add 1

101100 – add sign bit

Next 9 bits are unsigned integer

101010110

And last 16 bits are out shortened IEEE-754 float value.

0100100011101000

Where

0 – sign

1 – exponent sign

00100 – exponent

011101000 – mantissa value

Using writeCustomFloat/readCustomFloat methods you can change bit count needed for your float value, also remove sign bits.



And then we can read written data:
```
var data:ByteArray  = writer.byteArray;
data.position = 0; // will read from very start
var reader:MultibyteReader = new MultibyteReader(data);
trace(reader.readBoolean()); // true
trace(reader.read(6)); // -12
trace(reader.readUnsigned(9)); // 342
trace(reader.readCustomFloat(16, 6)); // 46.5
```
MultibyteReader and MultibyteWriter are designed to store numeric values – integers and float, to store strings and objects you can use MultibyteStream object that combined reader and writer capabilities.  MultibyteStream uses Data Maps to work properly. You should specify which properties/methods it should use to read and write data.
As example, I'll create custom class:
```
class Config{
	public var bool:Boolean;
	public var integer:int;
	public var unsigned:uint;
	public var float:Number;
	public var text:String;
}
```
Then I can instantiate it filling with some values:
```
var config:Config = new Config();
config.bool = true;
config.integer = -12;
config.unsigned = 342;
config.float = 46.5;
config.text = "Hello world!";
```
This object, as any other, can be used with MultibyteStream, I should specify it as a target object:
```
var stream:MultibyteStream = new MultibyteStream(null, config);
```
First parameter is NULL because MultibyteStream can create ByteArray on its own. Next we should tell it which properties of the target object can be used, this is data-map that should always be used to read saved data:
```
public function createDataMap(stream:MultibyteStream, target:Object):void{
	// start data map
	stream.add(MultibyteValueType.BOOLEAN, "bool");
	stream.addItem(new MultibyteInt(target, "integer", 6));
	stream.addItem(new MultibyteIntFlexible(target, "integer"));
	stream.addItem(new MultibyteFloat(target, "float", 6, 9));
	stream.addItem(new MultibyteString(target, "text"));
	// data map complete, now we can read/write using this data-map
}

createDataMap(stream, config);
```
MultibyteStream.addItem() method accepts IMultibyteValue objects that contain settings to read/write specified property and MultibyteStream.add() method uses default IMultibyteValue objects that will be crated based on type you want to save.
Then we can save data by writing it to ByteArray:
```
stream.write();
var data:ByteArray = stream.byteArray;
```
All data saved to ByteArray and we can get it from MultibyteStream.byteArray. To read data we can use same MultibyteStream object with already configured data-map, we can change target object by calling MultibyteStream.changeTarget(). But I'll create new config object and new Stream:
```
config = new Config();
stream = new MultibyteStream(data, config);
createDataMap(stream, config);
stream.read();
```
Most important thing to remember is – we must use exactly same data-map, all settings must be exactly same to read data properly.