import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2

Item{
    id: root

    function toNextDate(){
        tempDate.setDate(tempDate.getDate() + 1)
        calendar.selectedDate = tempDate
        tempDate = calendar.selectedDate
    }
    function toPrevDate(){
        tempDate.setDate(tempDate.getDate() - 1)
        calendar.selectedDate = tempDate
        tempDate = calendar.selectedDate
    }

    function showCalendar(tempDate){
        dialogCalendar.show(tempDate)
    }

    function switchTheme(){
        _style.isDarkTheme = !_style.isDarkTheme
    }

    function retMinDate(){
        return minDate;
    }

    property date minDate: new Date()

    Style{
        id: _style
    }
    Dialog{
        id: dialogCalendar
        width: Screen.desktopAvailableWidth * 10/48
        height: Screen.desktopAvailableHeight * 100/216
        title: "Календарь"
        //Сам календарь
        contentItem: Rectangle {
            id: dialogRect
            color: _style.backgroundColor
            //Кастомный календарь
            Calendar {
                id: calendar
                //Растягиваем его     
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: row.top
                minimumDate: minDate
                // Стилизуем Календарь
                style: CalendarStyle {

                    // Стилизуем navigationBar
                    navigationBar: Rectangle {
                        id: _navigation
                        /* Он будет состоять из прямоугольника,
                         * в котором будет располагаться две кнопки и label
                         * */
                        height: 48
                        color: _style.backgroundColor

                        /* Горизонтальный разделитель,
                         * который отделяет navigationBar от поля с  числами
                         * */
                        Rectangle {
                            color: _style.secondaryColor
                            height: 1
                            width: parent.width
                            anchors.bottom: parent.bottom
                        }

                        // Кнопка промотки месяцев назад
                        Button {
                            id: previousMonth
                            width: parent.height - 8
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 8

                            /* По клику по кнопке вызываем функцию
                             * календаря, которая отматывает месяц назад
                             * */
                            onClicked: control.showPreviousMonth()

                            // Стилизуем кнопку
                            style: ButtonStyle {
                                background: Rectangle {
                                    // Окрашиваем фон кнопки
                                    color: _navigation.color
                                    /* И помещаем изображение, у которго будет
                                     * два источника файлов в зависимости от того
                                     * нажата кнопка или нет
                                     */
                                    Image {
                                        source: _style.isDarkTheme ? (control.pressed ? "Img/left_arrow_darkTheme_pressed.png" : "Img/left_arrow_darkTheme.png")
                                                                   : (control.pressed ? "Img/left_arrow_whiteTheme_pressed.png" : "Img/left_arrow_whiteTheme.png")

                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.height - 8
                                        height: width
                                    }
                                }
                            }
                        }

                        // Помещаем стилизованный label
                        Label {
                            id: dateText
                            /* Забираем данные из title календаря,
                             * который в данном случае не будет виден
                             * и будет заменён данным label
                             */
                            text: styleData.title
                            color: _style.textColor
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: Math.min(dialogCalendar.height/25, dialogCalendar.width/20)
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: previousMonth.right
                            anchors.leftMargin: 2
                            anchors.right: nextMonth.left
                            anchors.rightMargin: 2
                        }

                        // Кнопка промотки месяцев вперёд
                        Button {
                            id: nextMonth
                            width: parent.height - 8
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            /* По клику по кнопке вызываем функцию
                             * календаря, которая отматывает месяц назад
                             * */
                            onClicked: control.showNextMonth()

                             // Стилизуем кнопку
                            style: ButtonStyle {
                                // Окрашиваем фон кнопки
                                background: Rectangle {
                                    color: _navigation.color
                                    /* И помещаем изображение, у которго будет
                                     * два источника файлов в зависимости от того
                                     * нажата кнопка или нет
                                     */
                                    Image {
                                        source: _style.isDarkTheme ? (control.pressed ? "Img/right_arrow_darkTheme_pressed.png" : "Img/right_arrow_darkTheme.png")
                                                                   : (control.pressed ? "Img/right_arrow_whiteTheme_pressed.png" : "Img/right_arrow_whiteTheme.png")
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.height - 8
                                        height: width
                                    }
                                }
                            }
                        }
                    }
                    //Дни недели
                    dayOfWeekDelegate: Rectangle{
                        height: dialogCalendar.height / 17
                        color: _style.backgroundColor
                        Label{
                            text: control.__locale.dayName(styleData.dayOfWeek, control.dayOfWeekFormat)
                            color: _style.themeInvertedColor
                            anchors.centerIn: parent
                        }
                    }

                    // Стилизуем отображением квадратиков с числами месяца
                    dayDelegate: Rectangle {
                        anchors.fill: parent
                        anchors.margins: styleData.selected ? -1 : 0
                        // Определяем цвет в зависимости от того, выбрана дата или нет
                        color: styleData.date !== undefined && styleData.selected ? _style.secondaryColor : _style.backgroundColor
                        opacity: _style.emphasisOpacity

                        // Задаём предопределённые переменные с цветами, доступные только для чтения
                        readonly property color invalidDateColor: "gray"

                        // Помещаем Label для отображения числа
                        Label {
                            id: dayDelegateText
                            text: styleData.date.getDate() // Устанавливаем число в текущий квадрат
                            font.bold: true
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: Math.min( dialogCalendar.height/35, dialogCalendar.width/28)

                            // Установка цвета
                            color: {
                                var theColor = invalidDateColor; // Устанавливаем невалидный цвет текста
                                if (styleData.valid) {
                                    /* Определяем цвет текста в зависимости от того
                                     * относится ли дата к выбранному месяцу или нет
                                     * */
                                    theColor = (styleData.visibleMonth) ? _style.textColor: invalidDateColor;
                                    if (styleData.selected)
                                        // Перекрашиваем цвет текста, если выбрана данная дата в календаре
                                        theColor = _style.backgroundColor;
                                }
                                theColor;
                            }
                        }
                    }
                }
            }

            // Делаем панель с кнопками
            Row {
                id: row
                height: 48
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                // Кнопка для закрытия диалога
                Button {
                    id: dialogButtonCalCancel
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: dialogCalendar.width / 2 - 1
                    style: ButtonStyle {
                        background: Rectangle {
                            color: _style.backgroundColor
                            opacity: control.pressed ? _style.secondaryOpacity : 1
                            border.width: 0
                        }

                        label: Text {
                            text: qsTr("Отмена")
                            font.pixelSize: Math.min( dialogCalendar.height/35, dialogCalendar.width/28)
                            color: _style.textColor
                            opacity: control.pressed ? _style.secondaryOpacity : 1
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                    // По нажатию на кнопку - просто закрываем диалог
                    onClicked:{
                        isWindowOpen = false
                        dialogCalendar.close()
                    }
                   }

                // Вертикальный разделитель между кнопками
                Rectangle {
                    id: dividerVertical
                    width: 2
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    color: "#d7d7d7"
                }

                // Кнопка подтверждения выбранной даты
                Button {
                    id: dialogButtonCalOk
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: dialogCalendar.width / 2 - 1
                    style: ButtonStyle {
                        background: Rectangle {
                            color: _style.backgroundColor
                            opacity: control.pressed ? _style.secondaryOpacity : 1
                            border.width: 0
                        }

                        label: Text {
                            text: qsTr("Принять")
                            font.pixelSize: Math.min( dialogCalendar.height/35, dialogCalendar.width/28)
                            color: _style.textColor
                            opacity: control.pressed ? _style.secondaryOpacity : 1
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    /* По клику по кнопке сохраняем выбранную дату во временную переменную
                     * и помещаем эту дату на кнопку в главном окне,
                     * после чего закрываем диалог
                     */
                    onClicked: {
                        tempDate = calendar.selectedDate
                        _chooseDate.text = Qt.formatDate(tempDate, "dd.MM.yyyy");
                        _taskList.loadTaskList()
                        _madeTasks.loadTaskList()
                        dialogCalendar.close()
                        isWindowOpen = false
                    }
                }
            }
        }

        /* Данная функция необходима для того, чтобы
         * установить дату с кнопки в календарь,
         * иначе календарь откроется с текущей датой
         */
        function show(x){
            calendar.selectedDate = x
            dialogCalendar.open()
        }
    }

}
