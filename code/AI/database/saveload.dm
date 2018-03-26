//�� ����, ��� ������ ��������� ��������� ������� ��� ��������� ��������

proc/save_aiknowledge()
	for(var/datum/AI_knowledge/AI0 in AI_knowledges)
		for(var/datum/word_category/category in AI0.categories)
			fdel("database/main/[AI0.language]/[category.name].txt")

			var/list/datum/word/sublist = list()//����������

			for(var/datum/word/WORD in category.words)//���������� �� �����������
				var/datum/word/subWORD = sublist.len ? sublist[length(sublist)] : null

				if(!subWORD || probe(WORD) < probe(subWORD))
					sublist += WORD
				else
					sublist = WORD + sublist

			save_simplelist(sublist, "database/main/[AI0.language]/[category.name].txt")

			if(AIDB_to_reserve==1)
				fdel("database/reserve/[AI0.language]/[category.name].txt")
				save_simplelist(sublist, "database/reserve/[AI0.language]/[category.name].txt")



proc/save_simplelist(var/list/L, var/savepath)
	var/savefile/F = new() //������ ������� ��������� ��� ������ � ����������

	F["len"] = L.len

	var/i = 1
	for(var/element in L)
		F[i] << L //���������� ���-�� � ������ ���� � ���� "����"
		i++

	F.ExportText("/",file(savepath)) //��������� ����� ����������. "/" - ����� �������




//--------------------------------------------------------------------------------------
//      ������� ���������� �����: ����� �������� ���������������� � ������ � �����
//--------------------------------------------------------------------------------------



proc/load_aiknowledge()
	for(var/lang in languages) //������� ��������� ��� ������, ���������������� �� ������
		var/datum/AI_knowledge/AI0 = new
		AI0.language = lang
		AI_knowledges += AI0

	for(var/datum/AI_knowledge/AI0 in AI_knowledges)//��������� ��� ��������� � ������������ � ���������� �������
		for(var/category in word_categories)//����� ��������� � ���� ����� ������������ �� �� �����, � �� ����� � ������ �����
			var/datum/word_category/AI1 = new
			AI1.name = category
			AI1.language = AI0.language
			AI1.words = list_from_file("database/[AIDB_from_reserve ? "reserve" : "main"]/[AI1.language]/[category].txt")
			for(var/datum/word/AI2 in AI1.words)
				AI2.language = AI1.language
			AI0.categories += AI1



proc/list_from_file(var/savepath)//���������� ��->���� �� ��������� �����������
	var/savefile/F = new()
	F.ImportText("/",file(savepath))

	var/Flen
	Flen << F["len"]
	var/list/return_list = list()

	for(var/i=1, i<=Flen, i++)
		var/datum/word/WORD
		WORD << F[i]
		return_list += WORD

	return return_list



	//if(copytext(log, i, i+1)!="\n")	text += copytext(log, i, i+1)
	//if(copytext(log, i, i+1)=="\n" || i==lentext(log))
	//if(text && probe(text)>=min_p && probe(text)<=max_p)	LIST += text
	//text = ""

/*




guest1523827786 = object(".0")
	.0
		type = /mob/player
		name = "Arthur"
		key = "guest1523827786"


*/


