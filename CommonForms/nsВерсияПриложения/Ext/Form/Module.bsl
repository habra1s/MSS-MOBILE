
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	RobotoThinURL = ПолучитьДанныеОбщегоМакета("RobotoThin", "RobotoThin.ttf");
	
	ПолеHTML = "
	|<!DOCTYPE html>
	|<html lang=""ru"">
	|<head>
	|    <meta charset=""UTF-8"">
	|    <title>Версия приложения</title>
	|    <script>
    |
	|        var queue = Array(); // Очередь событий
	|        var queueHead = -1; // Указатель на начало очереди
	|        var queueTail = -1; // Указатель на конец очереди
	|        var totalEventCount = 0; //Количество обработанных событий
	|
	|        //Помещение произвольных данных в очередь
	|        function pushEvent(dataEvent){
	|            if (queueHead == queueTail && queueHead > -1){ //Если очередь пуста, сбросим указатели
	|                queueHead = queueTail = -1;
	|            }
	|            queue[queueTail + 1] = JSON.stringify(dataEvent);//Преобразуем данные в JSON
	|            queueTail += 1;
	|            totalEventCount += 1;
	|        }
	|
	|        //Получение данных очереди по индексу
	|        function getEvent(index){
	|            return queue[index];
	|        }
	|
	|     </script>
	|</head>
	|
	|<body>
	|    <style>
	|        @font-face {
	|            font-family: Roboto Thin; /* Гарнитура шрифта */
	|            src: url(" + RobotoThinURL + "); /* Путь к файлу со шрифтом */
	|        }
	|        body {
	|            background: dimgrey;
	|            font-family: 'Roboto Thin', sans-serif;
	|        }
	|        section {
	|            color: white;
	|            border-radius: 1em;
	|            padding: 1em;
	|            position: absolute;
	|            top: 50%;
	|            left: 50%;
	|            margin-right: -50%;
	|            transform: translate(-50%, -50%);
	|            font-family: 'Roboto Thin', sans-serif;
	|        }
	|        a.button8 {
	|            display: block;
	|            color: white;
	|            font-weight: 700;
	|            font-size: 60px;
	|            text-decoration: none;
	|            text-align: center;
	|            user-select: none;
	|            padding: .5em 2em;
	|            outline: none;
	|            border: 2px solid;
	|            border-radius: 1px;
	|            transition: 0.2s;
	|            margin-left: auto;
	|            margin-right: auto;
	|        }
	|        a.button8:hover { background: rgba(255,255,255,.2); }
	|        a.button8:active { background: white; }
	|    </style>
	|    <section>
	|        <h1 style=""font-size: 100px; font-weight: 100;"">Текущая сборка</h1>
	|        <h2 style=""text-align: center; font-size: 100px; font-weight: 100;"">" + nsОбщегоНазначения.ТекущаяВерсия() + "</h2>
	|        <a id=""buttonClose"" href=""#"" class=""button8"">Закрыть</a>
	|    </section>
	|    <script>
	|        document.getElementById('buttonClose').onclick = function () {
	|            pushEvent({close:true});
	|        }
	|    </script>
	|</body>
	|</html>"

КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеОбщегоМакета(Ресурс, ИмяРесурса)
	КаталогВременныхФайлов = КаталогВременныхФайлов();
	МакетРесурса = ПолучитьОбщийМакет(Ресурс);
	МакетРесурса.Записать(КаталогВременныхФайлов + ИмяРесурса);
	Возврат ПутьКФайлуКакURL(КаталогВременныхФайлов + ИмяРесурса);
КонецФункции
 
&НаКлиентеНаСервереБезКонтекста
Функция ПутьКФайлуКакURL(сПуть)
    Возврат "file:///" + СокрЛП(СтрЗаменить(сПуть,"\","/"));
КонецФункции

&НаКлиенте
Процедура ПолеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	Если НЕ ДанныеСобытия.Href = Неопределено И ЗначениеЗаполнено(ДанныеСобытия.Href) Тогда   		
		ПолучитьИОбработатьДанные();		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьИОбработатьДанные()Экспорт
	ОкноДокумента = ЭтаФорма.Элементы.ПолеHTML.Документ.defaultView;
	Если ОкноДокумента = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Пока ОкноДокумента.queueHead < ОкноДокумента.queueTail Цикл //Если есть что-то в очереди
		Данные = ПрочитатьДанныеИзJSON(ОкноДокумента.getEvent(ОкноДокумента.queueHead + 1));
		ОкноДокумента.queueHead = ОкноДокумента.queueHead + 1;
		Если Данные.close = Истина Тогда
			Закрыть();
		КонецЕсли; 
	КонецЦикла; 	
КонецПроцедуры 

&НаСервереБезКонтекста
Функция ПрочитатьДанныеИзJSON(СтрокаJSON)
	Возврат nsОбщегоНазначения.ПрочитатьДанныеИзJSON(СтрокаJSON);
КонецФункции