
Функция ПроверитьДатуЗапрета(Дата) Экспорт
	
	ДатаЗапрета = Константы.ДатаЗапрета.Получить();
	
	Если ДатаЗапрета = Дата("00010101") Тогда
		Возврат Истина;
	Иначе
		Возврат Дата > ДатаЗапрета;
	КонецЕсли;	 			
			
КонецФункции