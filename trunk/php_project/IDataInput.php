<?php
interface IDataInput{
	/**
	 * ��������� �� ������ ������ ���������� ��������.
	 * @return boolean
	 */
	public function readBoolean();
	/**
	 * ��������� �� ������ ������ ���� �� ������.
	 * @return int
	 */
	public function readByte();
	/**
	 * ��������� �� ������ ������ ����� ������ ������, �������� ���������� length.
	 * @param $bytes ByteArray
	 * @param $offset uint
	 * @param $length uint
	 * @return boolean
	 */
	public function readBytes($bytes, $offset = 0, $length = 0);
	/**
	 * ��������� �� ������ ������ ����� IEEE 754 � ������� ��������� (64-���������) � ��������� �������.
	 * @return float
	 */
	public function readDouble();
	/**
	 * ��������� �� ������ ������ ����� IEEE 754 � ��������� ��������� (32-���������) � ��������� �������.
	 * @return float
	 */
	public function readFloat();
	/**
	 * ��������� �� ������ ������ 32-��������� ����� ����� �� ������.
	 * @return int
	 */
	public function readInt();
	/**
	 * ��������� ������ �� ������� ������, �������������� � ��������������� ������ AMF.
	 * @return resource
	 *
	public function readObject();
	*/
	/**
	 * ��������� �� ������ ������ 16-��������� ����� ����� �� ������.
	 * @return int
	 */
	public function readShort();
	/**
	 * ��������� �� ������ ������ ���� ��� �����.
	 * @return int
	 */
	public function readUnsignedByte();
	/**
	 * ��������� �� ������ ������ 32-��������� ����� ����� ��� �����.
	 * @return int
	 */
	public function readUnsignedInt();
	/**
	 * ��������� �� ������ ������ 16-��������� ����� ����� ��� �����.
	 * @return int
	 */
	public function readUnsignedShort();
	
	/**
	 * ��������� �� ������ ������ ������ UTF-8.
	 * @return string
	 * /
	public function readUTF();
	/**
	 * ��������� ������������������ ������ UTF-8, �������� ���������� length, �� ������ ������ � ���������� ������.
	 * @return string
	 * /
	public function readUTFBytes($length);
	/**
	 * ��������� �� ������ ������ ������������� ������ �������� ����� � �������������� ��������� ������ ������.
	 * @param $length int
	 * @param $charSet String
	 * @return string
	 * /
	public function readMultiByte($length, $charSet);
	*/
}

?>