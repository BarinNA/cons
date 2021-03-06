
// Получает структуру для создания новой аналитики
// 
// Параметры:
// Возвращаемое значение:
// 	Структура - Описание:
// * База 
// * Наименование 
// * Тип 
// * ИД 
Функция ПолучитьСтруктуруНовойАналитики() Экспорт
	
	Стр = Новый Структура;
	Стр.Вставить("База");
	Стр.Вставить("Наименование");
	Стр.Вставить("Тип");
	Стр.Вставить("ИдИсточник");
	Стр.Вставить("Объект");
	
	Возврат Стр;
	
КонецФункции	

// Создает новый элемент аналитики и вносит запись регистр соответствия
// 
// Параметры:
// 	СтрНовойАналитики - Структура - см. метод ПолучитьСтруктуруНовойАналитики()
// Возвращаемое значение:
//	СправочникСсылка.Аналитика
Функция СоздатьАналитику(СтрНовойАналитики) Экспорт
	
	НачатьТранзакцию();
	
	спрАналитика = Справочники.Аналитика.СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(спрАналитика, СтрНовойАналитики);
	спрАналитика.Записать();
	
	СтрНовойАналитики.Объект = спрАналитика.Ссылка;
	
	СоздатьЗаписьСоответствияАналитики(СтрНовойАналитики);
	
	ЗафиксироватьТранзакцию();
	
	Возврат спрАналитика.Ссылка;
	
КонецФункции

// Функция ищет аналитику по переданным параметрам в регистре соответствия
// 
// Параметры:
// 	База - СправочникСсылка.Базы - 
// 	Тип - Строка
// 	ИД - Строка
// Возвращаемое значение:
// 	СправочникСсылка.Аналитика - Пустая ссылка, если не нашли
Функция ПолучитьЗначениеАналитикиПоИД(База, Тип, ИД) Экспорт
		
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СоответствияОбъектовИнформационныхБаз.Объект
		|ИЗ
		|	РегистрСведений.СоответствияОбъектовИнформационныхБаз КАК СоответствияОбъектовИнформационныхБаз
		|ГДЕ
		|	СоответствияОбъектовИнформационныхБаз.База = &База
		|	И СоответствияОбъектовИнформационныхБаз.Тип = &Тип
		|	И СоответствияОбъектовИнформационныхБаз.ИдИсточник = &ИдИсточник";
	
	Запрос.УстановитьПараметр("База", База);
	Запрос.УстановитьПараметр("Тип", Тип);
	Запрос.УстановитьПараметр("ИдИсточник", ИД);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Справочники.Аналитика.ПустаяСсылка();
	КонецЕсли;	
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	
	Возврат ВыборкаДетальныеЗаписи.Объект;
	
КонецФункции	

//Функция возвращает ИД аналитики
//Параметры:
//	База - СправочникСсылка.Базы
//	Аналитика - СправочникСсылка.Аналитика
Функция ПолучитьИдАналитики(База, Аналитика) Экспорт
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СоответствияОбъектовИнформационныхБаз.ИдИсточник КАК ИдИсточник
		|ИЗ
		|	РегистрСведений.СоответствияОбъектовИнформационныхБаз КАК СоответствияОбъектовИнформационныхБаз
		|ГДЕ
		|	СоответствияОбъектовИнформационныхБаз.База = &База
		|	И СоответствияОбъектовИнформационныхБаз.Объект = &Объект";
	
	Запрос.УстановитьПараметр("База",   База);
	Запрос.УстановитьПараметр("Объект", Аналитика);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		ВызватьИсключение "Не удалось найти ИД аналитики по переданным параметрам: База-"+База + " Объект-"+Аналитика;	
	КонецЕсли; 
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	
	Возврат ВыборкаДетальныеЗаписи.ИдИсточник;
	
КонецФункции	

Процедура СоздатьЗаписьСоответствияАналитики(СтрНовойАналитики) Экспорт
	
	МЗ = РегистрыСведений.СоответствияОбъектовИнформационныхБаз.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МЗ, СтрНовойАналитики);	
	МЗ.Записать();
	
КонецПроцедуры