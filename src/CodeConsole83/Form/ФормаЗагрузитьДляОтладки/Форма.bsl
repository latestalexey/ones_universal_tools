﻿&НаКлиенте
Процедура ПриступимКОтладке(Команда)
	
	Закрыть(Новый Структура("Адрес, НеУдалятьИзХранилища", Адрес, НеУдалятьИзХранилища));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	РежимСКДПриИзменении(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСКДПриИзменении(Элемент)

	ТекстСкрипта = СтрШаблон("ВнешниеОбработки.Создать(""CodeConsole83"").%1, Новый УникальныйИдентификатор(""%2""))" 
	    , ?(РежимСКД, "ПоместитьЗапросСКДВоВременноеХранилище(СхемаКомпоновкиДанных, КомпановщикНастроек", "ПоместитьЗапросВоВременноеХранилище(Запрос")
		, ЭтаФорма.ВладелецФормы.УникальныйИдентификатор
	);
	
КонецПроцедуры
