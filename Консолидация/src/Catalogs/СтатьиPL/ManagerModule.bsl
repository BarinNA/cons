
Процедура ЗагрузитьДанныеИзИсточника(База) Экспорт
	
	Соединение = РаботаСHTTPСервисами.ПолучитьСоединение(База.Пользователь, База.Пароль);
	Запрос = РаботаСHTTPСервисами.ПолучитьЗапрос(База.СтрокаПодключения + "/PlIndex");

	Ответ = Соединение.Получить(Запрос);
	СтруктрураСтатей = РаботаСJSON.ПреобразоватьJSONВЗначение(Ответ.ПолучитьТелоКакСтроку());
	
	РекурсивноОбработатьСтатьиИсточника(СтруктрураСтатей.PL_list, Справочники.СтатьиPL.ПустаяСсылка());
		
КонецПроцедуры

Процедура РекурсивноОбработатьСтатьиИсточника(PL_list, Родитель)
	
	Для Каждого Стр Из PL_list Цикл
		
		Поиск = Справочники.СтатьиPL.НайтиПоНаименованию(Стр.name, Истина);
		
		Если Поиск.Пустая() Тогда
			ЭлементСправочника = Справочники.СтатьиPL.СоздатьЭлемент();
			ЭлементСправочника.Наименование = Стр.name;
			ЭлементСправочника.Порядок 		= Стр.order;
			ЭлементСправочника.Родитель 	= Родитель;
			ЭлементСправочника.Записать();
			Статья = ЭлементСправочника.Ссылка;
		Иначе
			Статья = Поиск;
		КонецЕсли;
				
		РекурсивноОбработатьСтатьиИсточника(Стр.PL_list, Статья);
		
	КонецЦикла;	
	
КонецПроцедуры

Процедура СинхронизироватьСИсточником(База) Экспорт
	
	СтрСправочника = Новый Структура("PL_list", Новый Массив);

	РекурсивноПодготовитьСтатьиСправочника(СтрСправочника.PL_list, Справочники.СтатьиPL.ПустаяСсылка());

	ТекстЗапроса = РаботаСJSON.ПреобразоватьЗначениеВJSON(СтрСправочника);
	
	Соединение = РаботаСHTTPСервисами.ПолучитьСоединение(База.Пользователь, База.Пароль);
	Запрос = РаботаСHTTPСервисами.ПолучитьЗапрос(База.СтрокаПодключения + "/PlIndex");
	Запрос.УстановитьТелоИзСтроки(ТекстЗапроса);
		
	Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	РаботаСHTTPСервисами.ПроверитьКодСостояния(Ответ.КодСостояния);	
		
КонецПроцедуры

Процедура РекурсивноПодготовитьСтатьиСправочника(Массив, Родитель)
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтатьиPL.Ссылка,
		|	СтатьиPL.Наименование КАК Name,
		|	СтатьиPL.Порядок КАК Order,
		|	СтатьиPL.Код КАК UID
		|ИЗ
		|	Справочник.СтатьиPL КАК СтатьиPL
		|ГДЕ
		|	СтатьиPL.Родитель = &Родитель";
	
	Запрос.УстановитьПараметр("Родитель", Родитель);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СтрЭлемента = Новый Структура("PL_list,Name,Order,UID", Новый Массив);
		ЗаполнитьЗначенияСвойств(СтрЭлемента, ВыборкаДетальныеЗаписи);
		
		РекурсивноПодготовитьСтатьиСправочника(СтрЭлемента.PL_list, ВыборкаДетальныеЗаписи.Ссылка);
		
		Массив.Добавить(СтрЭлемента);
		
	КонецЦикла;
		
КонецПроцедуры	
