<?php
interface IDataOutput{
	/**
	 * ���������� ���������� ��������.
	 * @param $value Boolean
	 */
	public function writeBoolean($value);
	/**
	 * ���������� ���� � ����� ������.
	 * @param $value int
	 */
	public function writeByte($value);
	/**
	 * ���������� � ����� ���� ������������������ ���� ������ length �� ��������� ������� ���� (bytes), ������� �� �������� offset (������ ������������� �� ����).
	 * @param $bytes ByteArray|string
	 * @param $offset uint
	 * @param $length uint
	 */
	public function writeBytes($bytes, $offset = 0, $length = 0);
	/**
	 * ���������� � ����� ������ ����� IEEE 754 � ������� ��������� (64-���������) � ��������� �������.
	 * @param $value float
	 */
	public function writeDouble($value);
	/**
	 * ���������� � ����� ������ ����� IEEE 754 � ��������� ��������� (32-���������) � ��������� �������.
	 * @param $value float
	 */
	public function writeFloat($value);
	/**
	 * ���������� � ����� ������ 32-��������� ����� ����� �� ������.
	 * @param $value int
	 */
	public function writeInt($value);
	/**
	 * ���������� ������ � ������ ������ � ��������������� ������� AMF.
	 * @param mixed
	 *
	public function writeObject(object:*);
	*/
	/**
	 * ���������� � ����� ������ 16-��������� ����� �����.
	 * @param $value int
	 */
	public function writeShort($value);
	/**
	 * ���������� � ����� ������ 32-��������� ����� ����� ��� �����.
	 * @param $value uint
	 */
	public function writeUnsignedInt($value);
	/**
	 * ���������� ������ UTF-8 � ����� ������.
	 * @param $value String
	 * /
	public function writeUTF($value); 
	/**
	 * ���������� ������ UTF-8 � ����� ������.
	 * @param $value String
	 * /
	public function writeUTFBytes($value);
	/**
	 * ���������� ������������� ������ � ����� ������ � �������������� ��������� ������ ������.
	 * @param $value String
	 * @param charSet String
	 * /
	public function writeMultiByte($value, $charSet);
	*/
}

?>