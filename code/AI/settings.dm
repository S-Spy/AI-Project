//! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
//-------------------------------------------


//�������� 0=��� � 1=��
var/AIDB_from_reserve = 0//�� ������������ ���������� ��. ��� �� ������ ����, ���� � ����������
//����������� ��� ������ ������� �� � ��� ������� ������� ��������������� � �� �������
//������, �� ��� ����� ����������� � �������� �����.
var/AIDB_to_reserve = 0//������������ ���������. ��� ������������ ���������� ��������� ���� ������ ������ � ��������.
//� ������, ���� ��� ������, �� ��������� ��� ����������� ������ �� �� ��� ����������� �������� ��������

//�� ������ ������������� ����������� ������, �������
//��������� ������ ��, � ������� ���� ���-��, �� ����. ������ ����������� �������.
//�� ������� �� ��������������


//-------------------------------------------
//! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !






var/list/datum/AI_knowledge/AI_knowledges = list()
var/list/word_categories = list("hello",
		"yes",
		"no",
		"follow me",
		"understand",
		"goodbye",
		"my name",
		"hate word")

var/list/neuron_question_words = list()
var/list/neuron_word_categories = list()







datum/AI_knowledge
	var/language
	var/list/categories = list()

datum/word_category
	var/name
	var/list/words = list()
	var/language = "ru"

datum/word//���� - ������ �����. ������ ��� ��� �������
	var/word
	var/success
	var/all
	var/language = "ru"
	var/category




world/Start()//�������� ������ �� ��
	load_aiknowledge()
	..()

world/HourLoop()
	save_aiknowledge()
	..()

world/End()
	save_aiknowledge()
	..()



/*
����, � ���� ������� ���������� ����� ��������, ��� �� ������� ���������� �����
�������� ������� �����, �� ���� ������, ��� � ������� ���� �� �� �������


*/


