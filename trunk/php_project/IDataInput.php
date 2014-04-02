<?php
interface IDataInput{
	/**
	 * Считывает из потока байтов логическое значение.
	 * @return boolean
	 */
	public function readBoolean();
	/**
	 * Считывает из потока байтов байт со знаком.
	 * @return int
	 */
	public function readByte();
	/**
	 * Считывает из потока байтов число байтов данных, заданное параметром length.
	 * @param $bytes ByteArray
	 * @param $offset uint
	 * @param $length uint
	 * @return boolean
	 */
	public function readBytes($bytes, $offset = 0, $length = 0);
	/**
	 * Считывает из потока байтов число IEEE 754 с двойной точностью (64-разрядное) и плавающей запятой.
	 * @return float
	 */
	public function readDouble();
	/**
	 * Считывает из потока байтов число IEEE 754 с одинарной точностью (32-разрядное) и плавающей запятой.
	 * @return float
	 */
	public function readFloat();
	/**
	 * Считывает из потока байтов 32-разрядное целое число со знаком.
	 * @return int
	 */
	public function readInt();
	/**
	 * Считывает объект из массива байтов, зашифрованного в сериализованный формат AMF.
	 * @return resource
	 *
	public function readObject();
	*/
	/**
	 * Считывает из потока байтов 16-разрядное целое число со знаком.
	 * @return int
	 */
	public function readShort();
	/**
	 * Считывает из потока байтов байт без знака.
	 * @return int
	 */
	public function readUnsignedByte();
	/**
	 * Считывает из потока байтов 32-разрядное целое число без знака.
	 * @return int
	 */
	public function readUnsignedInt();
	/**
	 * Считывает из потока байтов 16-разрядное целое число без знака.
	 * @return int
	 */
	public function readUnsignedShort();
	
	/**
	 * Считывает из потока байтов строку UTF-8.
	 * @return string
	 * /
	public function readUTF();
	/**
	 * Считывает последовательность байтов UTF-8, заданную параметром length, из потока байтов и возвращает строку.
	 * @return string
	 * /
	public function readUTFBytes($length);
	/**
	 * Считывает из потока байтов многобайтовую строку заданной длины с использованием заданного набора знаков.
	 * @param $length int
	 * @param $charSet String
	 * @return string
	 * /
	public function readMultiByte($length, $charSet);
	*/
}

?>