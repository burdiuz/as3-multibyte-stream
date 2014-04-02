<?php
/**
 * @property boolean endian
 */
class ByteArray extends Bytes implements IDataInput, IDataOutput{
	const SHORT_LENGTH = 16;
	const INT_LENGTH = 32;
	protected $_endian;
	public function __construct($data='', $endian=Endian::BIG_ENDIAN){
		parent::__constructor($data);
		$this->_endian = $endian;
	}
	public function __get($name){
		$value = null;
		switch($name){
			case 'endian':
				$value = $this->_endian;
			break;
			default:
				$value = parent::__get($name);
			break;
		}
		return $value;
	}
	public function __set($name, $value){
		switch($name){
			case 'endian':
				$this->_endian = $value==Endian::BIG_ENDIAN ? Endian::BIG_ENDIAN : Endian::LITTLE_ENDIAN;
			break;
			default:
				parent::__set($name, $value);
			break;
		}
	}
	public function readBytes($bytes, $offset = 0, $length = 0){
		
	}
	public function readDouble(){
		
	}
	public function readFloat(){
		
	}
	public function readInt(){
		
	}
	public function readShort(){
		
	}
	public function readUnsignedInt(){
		
	}
	public function readUnsignedShort(){
		
	}
	public function writeBytes($bytes, $offset = 0, $length = 0){
		
	}
	public function writeDouble($value){
		
	}
	public function writeFloat($value){
		
	}
	public function writeInt($value){
		
	}
	public function writeShort($value){
		
	}
	public function writeUnsignedInt($value){
		
	}
	/** DO WE NEED UTF-8 methods? 
	 *TODO: Research, is it possible to make multiByte read/write methods with PHP core API.
	public function readUTF(){
		
	}
	public function readUTFBytes($length){
		
	}
	public function readMultiByte($length, $charSet){
		
	}
	public function writeUTF($value){
		
	}
	public function writeUTFBytes($value){
		
	}
	public function writeMultiByte($value, $charSet){
		
	}
	*/
}

?>