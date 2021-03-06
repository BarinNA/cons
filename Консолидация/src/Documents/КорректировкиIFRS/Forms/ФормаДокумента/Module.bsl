#Область ОбработчикиСобытийФормы
	
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	ОбновитьДанныеПериодов();

КонецПроцедуры

&НаКлиенте
Процедура КорректировкиPLПериодДействияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.КорректировкиPL.ТекущиеДанные;
	ТекущиеДанные.ДатаНачала    = ТекущиеДанные.ПериодДействия.ДатаНачала;
	ТекущиеДанные.ДатаОкончания = ТекущиеДанные.ПериодДействия.ДатаОкончания;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ПроверитьКорректностьЗаполненияПериодаДействия(Отказ);

КонецПроцедуры

#КонецОбласти

#Область Команды

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

&НаСервере
Процедура ОбновитьДанныеПериодов()
	
	Для Каждого Стр Из Объект.КорректировкиPL Цикл
		
		Стр.Период = Новый СтандартныйПериод(Стр.ДатаНачала, Стр.ДатаОкончания);
		
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьКорректностьЗаполненияПериодаДействия(Отказ)
	
	ПустаяДата = Дата("00010101");
	
	Для Каждого Стр Из Объект.КорректировкиPL Цикл
		
		Если Стр.ДатаНачала = ПустаяДата ИЛИ Стр.ДатаОкончания = ПустаяДата Тогда
			Сообщить("Проверте корректность заполнения периода действия!");
			Отказ = Истина;
			Возврат;
		КонецЕсли;	
		
	КонецЦикла;
	
КонецПроцедуры



#КонецОбласти
