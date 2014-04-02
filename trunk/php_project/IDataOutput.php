<?php
interface IDataOutput{
	/**
	 * Записывает логическое значение.
	 * @param $value Boolean
	 */
	public function writeBoolean($value);
	/**
	 * Записывает байт в поток байтов.
	 * @param $value int
	 */
	public function writeByte($value);
	/**
	 * Записывает в поток байт последовательность байт длиной length из заданного массива байт (bytes), начиная со смещения offset (индекс отсчитывается от нуля).
	 * @param $bytes ByteArray|string
	 * @param $offset uint
	 * @param $length uint
	 */
	public function writeBytes($bytes, $offset = 0, $length = 0);
	/**
	 * Записывает в поток байтов число IEEE 754 с двойной точностью (64-разрядное) и плавающей запятой.
	 * @param $value float
	 */
	public function writeDouble($value);
	/**
	 * Записывает в поток байтов число IEEE 754 с одинарной точностью (32-разрядное) и плавающей запятой.
	 * @param $value float
	 */
	public function writeFloat($value);
	/**
	 * Записывает в поток байтов 32-разрядное целое число со знаком.
	 * @param $value int
	 */
	public function writeInt($value);
	/**
	 * Записывает объект в массив байтов в сериализованном формате AMF.
	 * @param mixed
	 *
	public function writeObject(object:*);
	*/
	/**
	 * Записывает в поток байтов 16-разрядное целое число.
	 * @param $value int
	 */
	public function writeShort($value);
	/**
	 * Записывает в поток байтов 32-разрядное целое число без знака.
	 * @param $value uint
	 */
	public function writeUnsignedInt($value);
	/**
	 * Записывает строку UTF-8 в поток байтов.
	 * @param $value String
	 * /
	public function writeUTF($value); 
	/**
	 * Записывает строку UTF-8 в поток байтов.
	 * @param $value String
	 * /
	public function writeUTFBytes($value);
	/**
	 * Записывает многобайтовую строку в поток байтов с использованием заданного набора знаков.
	 * @param $value String
	 * @param charSet String
	 * /
	public function writeMultiByte($value, $charSet);
	*/
}

?>