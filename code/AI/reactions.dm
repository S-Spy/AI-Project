// ---------- ���������� ���� ������� ----------------

mob/ai/proc
	Answer(var/category)
		switch(category)
			if("hello")
				Hello()
				return 1
			if("yes", "no")
				if(waiting_answer == 1)//!!!!!!!!!
					waiting_answer = 0
					/*if(word.category == "no")	Learn_Answer(last_things[2], 0)
					else 						Learn_Answer(last_things[2], 1)
					goto End*/
				//else nonunderstand_reaction()
			if("follow me")
				Follow()
				return 1
			if("goodbye")
				Goodbye()
				return 1
		return 0//���� ���������� ������� �� �������, �� �� ����� ���������������


	Hello()
		Say("[random_word()], [sender.name]")


	Goodbye()
		Say("[random_word("goodbye")], [sender.name]")
		if(sender in friends)	friends -= sender


	Learn_Answer(var/category, var/answer = 1)
		//����� ����� �� �����. ����� ����� ���������. ��������. ������� ����. ������� ����� � ���� �������
		var/datum/word/word = word_from_db(last_things[1], category, 0)
		word.success += answer
		word.all += 1
		Say("����� ������ � ����������� �������� �� [probe(word)]. ���������.")
		//����� ������� ������ �� ���������� ����� ���������
		//����� �������� ��������� ��������� � ������ �� �� ������� �� �����, ���� ���� �� ����������?


	Follow()
		Say("[random_word("yes", 0.3)], ����")
		follow = 1
		while(follow!=0 && !(sender in range(0)))
			sleep(2)
			walk_to(src, sender)