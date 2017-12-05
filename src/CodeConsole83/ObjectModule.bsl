﻿Перем Плагины;

Перем ФункциональностьПлагинов;

// ВнешниеОбработки.Создать("CodeConsole83").ПоместитьЗапросВоВременноеХранилище(Запрос);

Функция Инициализировать(МассивАдресовОбработок, УникальныйИдентификатор) Экспорт 
	
	ПлагиныЗагрузить(МассивАдресовОбработок);
	
	Возврат СохранитьСостояние(УникальныйИдентификатор);
	
КонецФункции

Функция ПоместитьЗапрос(Запрос, Знач Адрес = Неопределено) Экспорт 
	
	Если Адрес = Неопределено Тогда 
		Адрес = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	Возврат ПоместитьВоВременноеХранилище(ПолучитьДанныеЗапроса(Запрос), Адрес);
	
КонецФункции

Функция ПоместитьЗапросСКД(СхемаКомпоновкиДанных, Настройки, Знач Адрес = Неопределено) Экспорт 
	
	Если Адрес = Неопределено Тогда 
		Адрес = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	Возврат ПоместитьВоВременноеХранилище(ПолучитьДанныеЗапросаСКД(СхемаКомпоновкиДанных, Настройки), Адрес);
	
КонецФункции

Функция ПолучитьДанныеЗапроса(Запрос) Экспорт 
	
	#Если Клиент Тогда
		Запрос = Новый Запрос;
	#КонецЕсли	
	
	ДанныеЗапроса = Новый Структура("Текст, Параметры");

	ЗаполнитьЗначенияСвойств(ДанныеЗапроса, Запрос);
		
	Если Запрос.МенеджерВременныхТаблиц <> Неопределено Тогда 
		
		СхемаЗапроса = Новый СхемаЗапроса;
		СхемаЗапроса.УстановитьТекстЗапроса(Запрос.Текст);
		
		ВременныеТаблицыЗапроса = Новый Соответствие;
		Для Каждого Пакет Из СхемаЗапроса.ПакетЗапросов Цикл 
			
			Если ЗначениеЗаполнено(Пакет.ТаблицаДляПомещения) Тогда 
				
				ВременныеТаблицыЗапроса.Вставить(ВРег(Пакет.ТаблицаДляПомещения), Истина);
				
			КонецЕсли;
			
		КонецЦикла;
		
		ТекстыУстановкиВТ = "";
		
		
		Для каждого Таблица Из Запрос.МенеджерВременныхТаблиц.Таблицы Цикл 
			
			Если ВременныеТаблицыЗапроса[ВРег(Таблица.ПолноеИмя)] = Неопределено Тогда 
				
				ДанныеЗапроса.Параметры.Вставить(Таблица.ПолноеИмя, Таблица.ПолучитьДанные().Выгрузить());
				ТекстыУстановкиВТ = ТекстыУстановкиВТ + СтрШаблон("ВЫБРАТЬ * ПОМЕСТИТЬ %1 ИЗ &%1%2;%2", Таблица.ПолноеИмя, Символы.ПС);
				
			КонецЕсли;
			
		КонецЦикла;
		
		ДанныеЗапроса.Текст = ТекстыУстановкиВТ + ДанныеЗапроса.Текст;
		
	КонецЕсли;
	
	Возврат ДанныеЗапроса;
	
КонецФункции

Функция ПолучитьДанныеЗапросаСКД(СхемаКомпоновкиДанных, Знач Настройки) Экспорт 
	
	Настройки = ПолучитьНастройки(Настройки);
	
	#Если Клиент Тогда
	    Схема = Новый СхемаКомпоновкиДанных; 	
	    Настройки = Новый НастройкиКомпоновкиДанных; 	
	#КонецЕсли
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, ?(Настройки = Неопределено, СхемаКомпоновкиДанных.НастройкиПоУмолчанию, Настройки));
	
	ДанныеЗапроса = Новый Структура("Текст, Параметры", "", Новый Структура);

	ДанныеЗапроса.Текст = МакетКомпоновки.НаборыДанных[0].Запрос;
	
	Для Каждого Параметр Из МакетКомпоновки.ЗначенияПараметров Цикл 
				
		ДанныеЗапроса.Параметры.Вставить(Параметр.Имя, Параметр.Значение);
		
	КонецЦикла;
	
	Возврат ДанныеЗапроса;
	
КонецФункции

Функция ПолучитьНастройки(Компановщик)
	
	ТипКомпановщика = ТипЗнч(Компановщик);
	
	Если ТипКомпановщика = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда 

		Возврат Компановщик.ПолучитьНастройки();
		
	ИначеЕсли ТипКомпановщика = Тип("СхемаКомпоновкиДанных") Тогда 
		
		Возврат Компановщик.НастройкиПоУмолчанию;
		
	ИначеЕсли ТипКомпановщика = Тип("НастройкиКомпоновкиДанных") Тогда 
		
		Возврат Компановщик;
		
	ИначеЕсли ТипКомпановщика = Тип("ДинамическийСписок") Тогда
		
		Возврат Компановщик.КомпоновщикНастроек.Настройки;
		
	иначе 
		Возврат Неопределено; 
	КонецЕсли;
КонецФункции

#Область Работа_с_формой

процедура СоздатьКолонкиТЗ(Форма, ИмяТаблицы, Колонки) Экспорт 
	
	МассивРеквизитов = Новый Массив;
	
	Для Каждого Колонка из Колонки Цикл
		Если Колонка.Имя = "_Служебная" Тогда 
			Продолжить;
		КонецЕсли;
		
		РеквизитФормы = Новый РеквизитФормы(Колонка.Имя, Колонка.ТипЗначения, ИмяТаблицы);
		МассивРеквизитов.Добавить(РеквизитФормы);
		
	КонецЦикла;
	
	Форма.ИзменитьРеквизиты(МассивРеквизитов);
	
	ЭлементТаблица = Форма.Элементы[ИмяТаблицы];
	Для Каждого Колонка из Колонки цикл
		
		Если Колонка.Имя = "_Служебная" Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ИмяКолонки = ИмяТаблицы + Колонка.Имя;
		Элемент = Форма.Элементы.Найти(ИмяКолонки);
		
		Если Элемент = Неопределено Тогда
			
			Элемент = Форма.Элементы.Добавить(ИмяКолонки, Тип("ПолеФормы"), ЭлементТаблица);

			Элемент.ПутьКДанным = СтрШаблон("%1.%2", ИмяТаблицы, Колонка.Имя);

		КонецЕсли;
		
		Элемент.Вид = ВидПоляФормы.ПолеВвода;
		Элемент.Заголовок = Колонка.Имя;
		
	КонецЦикла;
	
	Если Форма.Элементы.Найти(ИмяТаблицы + "_Служебная") <> Неопределено Тогда 
		
		Форма.Элементы[ИмяТаблицы + "_Служебная"].Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьКолонкиТЗ(Форма, ИмяТаблицы, Колонки) Экспорт 
	
	МассивУдаляемыхРеквизитов = Новый Массив;
	
	Для Каждого Колонка из Колонки цикл
		Если Колонка.Имя = "_Служебная" Тогда 
			Продолжить;
		КонецЕсли;
		
		МассивУдаляемыхРеквизитов.Добавить(СтрШаблон("%1.%2", ИмяТаблицы, Колонка.Имя));
	КонецЦикла;
	
	Форма.ИзменитьРеквизиты(, МассивУдаляемыхРеквизитов);
	
	Для Каждого Колонка из Колонки цикл
		
		Если Колонка.Имя = "_Служебная" Тогда 
			Продолжить;
		КонецЕсли;
		
		ИмяКолонки = ИмяТаблицы + Колонка.Имя;
		Элемент = Форма.Элементы.Найти(ИмяКолонки);
		Форма.Элементы.Удалить(Элемент);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьКолонкиТЗ(Форма, ИмяТаблицы, СтарыеКолонки, НовыеКолонки) Экспорт 
	
	ДобавляемыеКолонки = Новый Массив;
	УдаляемыеКолонки = Новый Массив;
	
	СоответствиеСтарые = ВСоответствие(СтарыеКолонки, "Имя");
	СоответствиеНовые = ВСоответствие(НовыеКолонки, "Имя");
	
	Для Каждого Колонка Из СтарыеКолонки Цикл 
		
		НайденнаяКолонка = СоответствиеНовые.Получить(Колонка.Имя);
		
		Если НайденнаяКолонка = Неопределено ИЛИ НайденнаяКолонка.ТипЗначения <> Колонка.ТипЗначения Тогда 
			
			УдаляемыеКолонки.Добавить(Колонка);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Колонка Из НовыеКолонки Цикл 
		
		НайденнаяКолонка = СоответствиеСтарые.Получить(Колонка.Имя);
		
		Если НайденнаяКолонка = Неопределено ИЛИ НайденнаяКолонка.ТипЗначения <> Колонка.ТипЗначения Тогда 
			
			ДобавляемыеКолонки.Добавить(Колонка);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если УдаляемыеКолонки.Количество() Тогда 
		УдалитьКолонкиТЗ(Форма, ИмяТаблицы, УдаляемыеКолонки);
	КонецЕсли;
	Если ДобавляемыеКолонки.Количество() Тогда 
		СоздатьКолонкиТЗ(Форма, ИмяТаблицы, ДобавляемыеКолонки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти //Работа_с_формой

#Область Плагины

Функция ПлагиныЗагрузить(МассивАдресовОбработок) Экспорт 
	
	ФункциональностьПлагинов = Новый Соответствие;
	Плагины = Новый Соответствие;
	
	Для Каждого Файл из МассивАдресовОбработок Цикл 
		
		Попытка
			
			ИмяПлагина = Неопределено;
			ИмяПлагина = ВнешниеОбработки.Подключить(Файл);
			Плагин = ВнешниеОбработки.Создать(ИмяПлагина);
			
			ОписаниеПлагина = Плагин.ОписаниеПлагина();
					
			Для Каждого Функциональность Из ОписаниеПлагина.Функциональность Цикл 
				
				Если ФункциональностьПлагинов[Функциональность] = Неопределено Тогда 
					
					ФункциональностьПлагинов.Вставить(Функциональность, Новый Массив);
					
				КонецЕсли;
				
				ФункциональностьПлагинов[Функциональность].Добавить(Плагин);
				
			КонецЦикла;
			
		Исключение
			
			Сообщить(СтрШаблон("Загрузка плагинов. [%1]%2%3", ИмяПлагина, Символы.ПС, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецФункции

Функция СохранитьСостояние(АдресДанных) Экспорт 
	
	Состояние = Новый Структура("Плагины, ФункциональностьПлагинов", Плагины, ФункциональностьПлагинов);
	
	Возврат ПоместитьВоВременноеХранилище(Состояние, АдресДанных);
	
КонецФункции // СохранитьСостояние

Функция ВосстановитьСостояние(АдресДанных) Экспорт 
	
	Если НЕ ЭтоАдресВременногоХранилища(АдресДанных) Тогда 
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Состояние = ПолучитьИзВременногоХранилища(АдресДанных);
	Плагины = Состояние.Плагины;
	ФункциональностьПлагинов = Состояние.ФункциональностьПлагинов;
	
КонецФункции // ВосстановитьСостояние

Функция ПлагиныПолучитьСериализатор(Тип, Формат)
	
	Для каждого Плагин Из ФункциональностьПлагинов["Сериализация"] Цикл 
		
		Если Плагин.ЕстьПоддержкаСериализации(Тип, Формат) Тогда 
			
			Возврат Плагин;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

#КонецОбласти //Плагины

#Область Сериализация

Функция СохранитьЗначение(Знач Значение, Формат) Экспорт 
	
	Если ЭтоАдресВременногоХранилища(Значение) Тогда 
		
		Значение = ПолучитьИзВременногоХранилища(Значение);
		
	КонецЕсли;
	
	Тип = ТипЗнч(Значение);
	
	Плагин = ПлагиныПолучитьСериализатор(Тип, Формат);
	
	Если Плагин = Неопределено Тогда 
		
		ВызватьИсключение СтрШаблон("Не поддерживается сохранение ""%1"" в формате ""%2""", Тип, Формат);
		
	КонецЕсли;
	
	Возврат ПоместитьВоВременноеХранилище(Плагин.СохранитьЗначение(Значение, Формат));
	
КонецФункции

Функция ЗагрузитьЗначение(Знач Данные, Формат, Тип) Экспорт 

	Если ЭтоАдресВременногоХранилища(Данные) Тогда 
		
		Данные = ПолучитьИзВременногоХранилища(Данные);
		
	КонецЕсли;
	
	Плагин = ПлагиныПолучитьСериализатор(Тип, Формат);
	
	Если Плагин = Неопределено Тогда 
		
		ВызватьИсключение СтрШаблон("Не поддерживается загрузка ""%1"" в формате ""%2""", Тип, Формат);
		
	КонецЕсли;
	
	Возврат Плагин.ЗагрузитьЗначение(Данные, Формат, Тип);
	

КонецФункции // ЗагрузитьЗначение()


Функция ПолучитьФорматыСохранения(Тип) Экспорт 
	
	Форматы = Новый Соответствие;
	
	Для каждого Плагин Из ФункциональностьПлагинов["Сериализация"] Цикл
		
		Для Каждого Формат Из Плагин.ПолучитьФорматыСериализации(Тип) Цикл 
			
			Форматы.Вставить(Формат.Ключ, Формат.Значение);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Форматы;
	
КонецФункции

#КонецОбласти //Сериализация

#Область Коллекции

Функция ВСоответствие(Коллекция, Ключ, Значение = Неопределено)
	
	Соответствие = Новый Соответствие;
	
	Для Каждого Стр Из Коллекция Цикл 
		
		Соответствие.Вставить(Стр[Ключ], ?(Значение = Неопределено, Стр, Стр[Значение]));
		
	КонецЦикла;
	
	Возврат Соответствие;
	
КонецФункции

#КонецОбласти //Коллекции
