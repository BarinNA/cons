
Функция ПреобразоватьЗначениеВJSON(Значение) Экспорт
	
	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON());
	ЗаписатьJSON(ЗаписьJSON, Значение);
	JSON = ЗаписьJSON.Закрыть();
	
	Возврат JSON;
	
КонецФункции	

Функция ПреобразоватьJSONВЗначение(json, ПоляДаты = Неопределено) Экспорт
	
	Если ПоляДаты = Неопределено Тогда
		
		ПоляДаты = "StartDate,EndDate";	
		
	КонецЕсли;	
	
	Чтение = Новый ЧтениеJSON();
	Чтение.УстановитьСтроку(json);
	Значение = ПрочитатьJSON(Чтение,,ПоляДаты);
	Чтение.Закрыть();
	
	Возврат Значение;
	
КонецФункции