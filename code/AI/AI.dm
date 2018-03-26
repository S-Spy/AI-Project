obj/var/ai = 0//��=1,2,3; �����=-1

mob
	ai
		icon_state = "ai"
		var/send
		var/atom/sender
		var/follow = 0
		var/lq = 1//������� ��� ������� ��������
		var/list/viewing = list()
		var/list/friends = list()
		var/waiting_answer = 0
		var/list/last_things = list()


		New()
			sleep(3)
			for(var/mob/M in view())
				if(M!=usr)	View_Move(M)

		View_Move(var/atom/movable/A)//����� �������� �� �������������� ����������� �� ���
			..()
			if(!(A in viewing))
				viewing += A
				var/N = ", [A.name]"
				if(!A || !A.name)	N = ""
				Say("[random_word()][N]. � ������������� ���������. ����������, ��������� ��������� ����� \"[random_word("my name")], \" ��� \", [random_word("my name")]\" ��� ������� �� ����. � ��� �� �� ��������� ����� ������ �����������. � ���� � ���� ���� ���������. �������.")


		//src - ������ ��
		//sender - ������ ���, ���� �������
		//usr - ������ �����, ������ ��� ��. �� ������������

		Hear(var/text, var/atom/s)
			..()
			spawn(5)//����� �������
				send = lowertextru(text)
				sender = s
				var/category
				if(sender!=src && !(sender in friends))
					friends += sender
					category = "hello"
				//world << "usr=\icon[usr][usr] + src=\icon[src][src] + sender=\icon[sender][sender]"
				var/list/movable_visibles = list()
				for(var/atom/movable/V in view(sender))
					if(ismob(V) || (isobj(V)&&V:ai))	movable_visibles += V//����� �������� ������� ������� �� ��� ��������


				var/request//����� ��������� � ������� �� ����
				for(var/ainame in list_words("my name", 0.3))
					if(findtext(send, "[ainame],", 1, lentext(ainame)+2))
						request = ainame
						send = copytext(send, lentext(ainame)+2)
						world << send
					else if(findtext(send, ", [ainame]", -lentext(ainame)-2))
						request = ainame
						send = copytext(send, 1, -lentext(ainame)-2)
				//world << "usr=[usr] + src=[src] + sender=[sender] + request=\"[request]\""


				if(findtext(send, "start learning"))
					Say(random_word("understand", 0.3))
					lq = 1
				else if(findtext(send, "stop learning"))
					Say(random_word("understand", 0.3))
					lq = 0
				//�������� ������� ���������� ������ ��������� ��� ����������� ���������
				else if(request || (movable_visibles.len==2 && sender!=src))
					Reaction(category, request)
//�������� ������� �������� ����������� - ��������� ����������� ���������, ��������� ��

		proc//� ��������� ����� - �������� ��������
			Follow()
				Say("[random_word("yes", 0.3)], ����")
				follow = 1
				while(follow!=0 && !(sender in range(0)))
					sleep(2)
					walk_to(src, sender)

//�������� ��������� ������������� ��������������� �����... �� ���� ��?


			Reaction(var/probe_category, var/request)//��������� �������������� ������ �� ���������
				//���� ����� �������� �������, �� ��������, ����������� �� ���
				//���� ������, �� ������ ��������� ���������� ��� ����� �� ���� ������ �����

				//�������������� �������-���������
				var/signal = cleaning_signal(send)
				var/lang = detected_language_ruen(text)
				//����� ��������� �������
				var/list/datum/AI_word/LIST = list()
				for(var/category in AI_categories)//������� ��� ��������� ��������� � ��������������� �� �����������
					var/datum/AI_word/AI2 = word_from_db(signal, category, 0)
					if(AI2)//����� �������. ������ ������� ���������� � ����
						for(var/datum/AI_word/subAI2 in LIST)
							if(probe(AI2)-probe(subAI2)>0.1)
								LIST -= subAI2
								goto ADD
							if(!LIST.len) goto ADD
							goto jump; ADD; LIST += AI2; jump //����� ���������� �� �������� ���




				//��������� ��������� - �����������
				if(!LIST.len && probe_category)
					word2db(signal, probe_category, lang)
					LIST += word_from_db(signal, probe_category, 0)


				//���� �������� ������ ����� ����� ������ ������
				var/new_word = 0
				if(!LIST.len)
					new_word = 1

					var/msg = "������� ��������� ��� � ���� ������. "
					if(waiting_answer==1)
						probe_category = alert(sender,
						"[msg]����� ��������, ��� ��� ����������� � ����� �� ������ ���������. �����������, ����������.",
						"Category","yes", "no", "��� �� �� ������ ���������")
						if(probe_category!="��� �� �� ������ ���������")	goto jumpy
					msg += "����������, �������� ��������� ������� ��������� ��� ������ � ���� ��������."
					probe_category = input(sender, msg, "Category", "hello") in AI_categories+"CANCEL"
					if(probe_category == "CANCEL")	goto End
					jumpy
					word2db(signal, probe_category, lang)
					LIST += word_from_db(signal, probe_category, 0)

				var/datum/AI_word/word = pick(LIST)

				//�������� �����, �������� ��������
				//������� ��������� ������� �������

				//�������-����� �� ������
				switch(word.category)
					if("hello")
						Hello()
					if("yes", "no")
						if(waiting_answer == 1)
							waiting_answer = 0
							if(word.category == "no")	Learn_Answer(last_things[2], 0)
							else 						Learn_Answer(last_things[2], 1)
							goto End
						//else nonunderstand_reaction()
					if("follow me")
						Follow()
					if("goodbye")
						Goodbye()


				//���� ��� ��������
				if(lq && !waiting_answer && !new_word)	for(var/datum/AI_word/AI2 in LIST)//��������� ����������� ����������� � �������
					if(difference(signal, AI2.word)==0)
						Say("[probe2text(probe(AI2))]�������, ��� ��������� \"[signal]\" ����������� � ��������� [word.category]. ��� ������ �� ��������?")
						waiting_answer = 1
						last_things.Cut()
						last_things += signal
						last_things += word.category
						break
				End

			Hello()
				Say("[random_word()], [sender.name]")

			Goodbye()
				Say("[random_word("goodbye")], [sender.name]")
				if(sender in friends)	friends -= sender

			Learn_Answer(var/category, var/answer = 1)
				//����� ����� �� �����. ����� ����� ���������. ��������. ������� ����. ������� ����� � ���� �������
				var/datum/AI_word/word = word_from_db(last_things[1], category, 0)
				word.success += answer
				word.all += 1
				Say("����� ������ � ����������� �������� �� [probe(word)]. ���������.")
				//����� ������� ������ �� ���������� ����� ���������
				//����� �������� ��������� ��������� � ������ �� �� ������� �� �����, ���� ���� �� ����������?
