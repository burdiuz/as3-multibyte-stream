<?php
/**
 * @property string data
 * @property int position
 * @property int bytesAvailable
 * @property int length
 * @property boolean useTwosComplement
 */
class Bytes{
	const SIGN_BIT = 0x80;
	const BYTE_LENGTH = 8;
	const BYTE_MASK = 0xFF;
	const UNSIGNED_MASK = 0x7F;
	/**
	 * @var string
	 */
	protected $_data;
	protected $_length;
	protected $_position;
	protected $_useTwosComplement;
	public function __construct($data='', $useTwosComplement=true){
		$this->data = $data;
		$this->_useTwosComplement = $useTwosComplement;
	}
	public function __get($name){
		$value = null;
		switch($name){
			case 'data':
				$value = $this->_data;
			break;
			case 'position':
				$value = $this->_position;
			break;
			case 'bytesAvailable':
				$value = $this->_length-$this->_position;
			break;
			case 'length':
				$value = $this->_length;
			break;
			case 'useTwosComplement':
				$value = $this->_useTwosComplement;
			break;
			default:
				throw new Exception('Undefined property "'.$name.'" requested.');
			break;
		}
		return $value;
	}
	public function __set($name, $value){
		switch($name){
			case 'position':
				if($this->_position<=$this->_length){
					$this->_position = $value;
				}else{
					throw new Exception("Position is out of bounds");
				}
			break;
			case 'data':
				$this->_data = (string)$value;
				$this->_length = strlen($this->_data);
				$this->_position = 0;
			break;
			default:
				throw new Exception('Undefined property "'.$name.'" requested.');
			break;
		}
	}
	public function readBoolean(){
		return (boolean)$this->readUnsignedByte();
	}
	public function readByte(){
		return self::convertToSignedForm($this->readUnsignedByte(), self::BYTE_LENGTH, $this->_useTwosComplement);
	}
	public function readUnsignedByte(){
		if($this->_position<$this->_length){
			$value = ord($this->_data[$this->_position++]);
		}else{
			throw new Exception("Position is out of bounds");
		}
		return $value;
	}
	public function writeBoolean($value){
		$this->writeByte($value ? 1 : 0);
	}
	/*
	 * Negative numbers in PHP stored as 32 bit two's complement numbers
	 * echo strlen(decbin(-127));
	 * http://en.wikipedia.org/wiki/Two's_complement
	 */
	public function writeByte($value){
		$this->writeUnsignedByte(self::convertToUnsignedForm($value, self::BYTE_LENGTH, $this->_useTwosComplement));
	}
	protected function writeUnsignedByte($value){
		$this->_data[$this->_position++] = chr(((int)$value) & self::BYTE_MASK);
		if($this->_position>$this->_length){
			$this->_length = $this->_position;
		}
	}
	public function clear(){
		$this->_data = '';
		$this->_position = 0;
		$this->_length = 0;
	}
}

$bytes = new Bytes("abc", true);
//read test
echo $bytes->readUnsignedByte().'<br/>';
echo $bytes->readUnsignedByte().'<br/>';
echo $bytes->readUnsignedByte().'<br/>';
//boolean test
$bytes->writeBoolean(false);
$bytes->position--;
echo $bytes->readBoolean().'<br/>';
$bytes->writeBoolean(true);
$bytes->position--;
echo $bytes->readBoolean().'<br/>';
$bytes->writeBoolean(false);
$bytes->position--;
echo $bytes->readBoolean().'<br/>';
$bytes->writeBoolean(true);
$bytes->position--;
echo $bytes->readBoolean().'<br/>';
//positive test
$bytes->writeByte(255);
$bytes->position--;
echo $bytes->readUnsignedByte().'<br/>';
$bytes->writeByte(1);
$bytes->position--;
echo $bytes->readUnsignedByte().'<br/>';
$bytes->writeByte(127);
$bytes->position--;
echo $bytes->readUnsignedByte().'<br/>';
$bytes->writeByte(23);
$bytes->position--;
echo $bytes->readUnsignedByte().'<br/>';
$bytes->writeByte(7);
$bytes->position--;
echo $bytes->readUnsignedByte().'<br/>';
//negative test
$bytes->writeByte(-1);
$bytes->position--;
echo $bytes->readByte().'<br/>';
$bytes->writeByte(-127);
$bytes->position--;
echo $bytes->readByte().'<br/>';
$bytes->writeByte(-23);
$bytes->position--;
echo $bytes->readByte().'<br/>';
$bytes->writeByte(-7);
$bytes->position--;
echo $bytes->readByte().'<br/>';

?>