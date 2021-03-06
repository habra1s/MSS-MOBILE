﻿Функция ЗаписатьОшибку(Событие, КонтекстОшибки = Неопределено) Экспорт
	Возврат ЗаписатьЛог(Перечисления.nsУровниЛога.Ошибка, Событие, КонтекстОшибки);		
КонецФункции

Функция ЗаписатьИнформацию(Событие, КонтекстОшибки = Неопределено) Экспорт
	Возврат ЗаписатьЛог(Перечисления.nsУровниЛога.Информация, Событие, КонтекстОшибки);		
КонецФункции

Функция ЗаписатьЛог(УровеньЛога, Событие, КонтекстОшибки)
	
	Попытка
		Если ТипЗнч(Событие) = Тип("ИнформацияОбОшибке") Тогда
			СобытиеТекст = ПолучитьИнформациюОбОшибке(Событие);	
		ИначеЕсли ТипЗнч(Событие) = Тип("HTTPЗапрос") Тогда 
			СобытиеТекст = ПолучитьИнфоHTTPЗапрос(Событие);	
		ИначеЕсли ТипЗнч(Событие) = Тип("HTTPОтвет") Тогда 
			СобытиеТекст = ПолучитьИнфоHTTPОтвет(Событие);	
		Иначе	
			СобытиеТекст = Строка(Событие);	
		КонецЕсли; 
	Исключение
		СобытиеТекст = Строка(Событие);	
	КонецПопытки; 
	
	Попытка
		МенеджерЗаписи = РегистрыСведений.nsLog.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Период = ТекущаяДата();
		МенеджерЗаписи.УровеньЛога = УровеньЛога;
		МенеджерЗаписи.КонтекстОшибки = КонтекстОшибки;
		МенеджерЗаписи.Событие = СобытиеТекст;
		МенеджерЗаписи.Записать();
	Исключение
	КонецПопытки; 
	
	Возврат Неопределено;
КонецФункции

Функция ПолучитьИнформациюОбОшибке(ИнформацияОбОшибке, Параметр1 = Неопределено)
	
	ОшибкаТекст = ИнформацияОбОшибке.Описание + Символы.ПС +
		ИнформацияОбОшибке.ИмяМодуля + Символы.ПС +
		ИнформацияОбОшибке.НомерСтроки + Символы.ПС +
		ИнформацияОбОшибке.ИсходнаяСтрока;
		
	Если ЗначениеЗаполнено(Параметр1) Тогда
		ОшибкаТекст = ОшибкаТекст + Символы.ПС + Параметр1;	
	КонецЕсли; 	
	
	Возврат ОшибкаТекст;
КонецФункции
 
Функция ПолучитьИнфоHTTPЗапрос(Событие)
	// TODO надо получать детальную информацию из запроса
	Возврат Строка(Событие);
КонецФункции
 
Функция ПолучитьИнфоHTTPОтвет(Событие)
	// TODO надо получать детальную информацию из ответа
	Возврат Строка(Событие);
КонецФункции
