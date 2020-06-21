import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.12
import QSystemTrayIcon 1.0
import QtQuick.Controls 1.4

ApplicationWindow {
    id: _mainWindow
    visible: true
    width: Screen.desktopAvailableWidth * 10000/20625
    height: Screen.desktopAvailableHeight * 10/15
    minimumWidth: Screen.desktopAvailableWidth * 10000/20625
    minimumHeight: Screen.desktopAvailableHeight * 10/15
    title: qsTr("Планировщик задач")

    QSystemTrayIcon {
        id: systemTray

        // Первоначальная инициализация системного трея
        Component.onCompleted: {
            icon = iconTray             // Устанавливаем иконку
            // Задаём подсказку для иконки трея
            toolTip = "Планировщик задач"
            show();
        }

        /* По клику на иконку трея определяем,
             * левой или правой кнопкой мыши был клик.
             * Если левой, то скрываем или открываем окно приложения.
             * Если правой, то открываем меню системного трея
             * */
        onActivated: {
            if(reason === 1){
                trayMenu.popup()
            } else {
                if(_mainWindow.visibility === Window.Hidden) {
                    _mainWindow.show()
                } else {
                    _mainWindow.hide()
                }
            }
        }
    }

    // Меню системного трея
    Menu {
        id: trayMenu
        MenuItem {
            text: qsTr("Развернуть окно")
            onTriggered: _mainWindow.show()
        }
        MenuItem{
            text: qsTr("Отмена")
        }

        MenuItem {
            text: qsTr("Выход")
            onTriggered: {
                systemTray.hide()
                Qt.quit()
            }
        }        
    }

    // Обработчик события закрытия окна
    onClosing: {
        close.accepted = false
        _mainWindow.hide()
    }

    /* Создадим переменную для хранения даты, чтобы не заморачиваться
     * с конвертацией типов
     * */
    property var tempDate: new Date();
    property bool isWindowOpen: false

    color: _style.backgroundColor

    Cal_show{
        id: _cal_show
    }

    Style{
        id: _style
    }

    TaskDescription{
        id: _TaskDesc
    }

    //Выбор даты
    Button {
        id: _chooseDate
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - width) / 2 - _chooseDate_2.width/2
        anchors.topMargin: parent.height / 72
        width: parent.width * 1/10
        height: parent.height / 20
        enabled: !isWindowOpen
        // По клику на кнопку запускаем диалоговое окно черз кастомную функцию
        onClicked: {
            _cal_show.showCalendar(tempDate)
        }
        // Устанавливаем текущую дату при запуске приложения на кнопку
        style: ButtonStyle{
            background: Rectangle {
                // Окрашиваем фон кнопки
                color: _mainWindow.color
            }
            label: Text{
                id: dateText
                text: Qt.formatDate(tempDate, "dd.MM.yyyy");
                font.pixelSize: _chooseDate.width / 5
                opacity: control.pressed ? _style.secondaryOpacity : 1
                color: _style.themeInvertedColor
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
    //Выбор даты 2(Иконка)
    Button{
        id: _chooseDate_2
        anchors.top: parent.top
        anchors.left: _chooseDate.right
        anchors.topMargin: _chooseDate.anchors.topMargin
        height: _chooseDate.height
        width: height
        enabled: !isWindowOpen
        onClicked: {
            _cal_show.showCalendar(tempDate)
        }
        style: ButtonStyle{
            background: Rectangle {
                // Окрашиваем фон кнопки
                color: _style.backgroundColor
                Image {
                    source: _style.isDarkTheme ? (control.pressed  ? "Img/calDarkPressed.png" : "Img/calDark.png")
                                               : (control.pressed  ? "Img/calWhitePressed.png" : "Img/calWhite.png")
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.height - 8
                    height: width
                }
            }
        }
    }
    //Стрелочка даты назад
    Button{
        id: prevDate
        anchors.top: parent.top
        anchors.right: _chooseDate.left
        anchors.topMargin: _chooseDate.anchors.topMargin
        height: _chooseDate.height
        width: height
        enabled: !isWindowOpen
        onClicked: {
            _cal_show.toPrevDate()
            _taskList.loadTaskList()
            _madeTasks.loadTaskList()
        }
        style: ButtonStyle{
            background: Rectangle {
                // Окрашиваем фон кнопки
                color: _style.backgroundColor
                Image {
                    source: _style.isDarkTheme ? (control.pressed ? "Img/left_arrow_darkTheme_pressed.png" : "Img/left_arrow_darkTheme.png")
                                               : (control.pressed ? "Img/left_arrow_whiteTheme_pressed.png" : "Img/left_arrow_whiteTheme.png")
                    anchors.verticalCenter: parent.verticalCenter
                    width: (tempDate.getDate() === _cal_show.minDate.getDate()) ? 0 : parent.height - 12
                    height: width
                }
            }
        }
    }
    //Стрелочка даты вперёд
    Button{
        id: nextDate
        anchors.top: parent.top
        anchors.left: _chooseDate_2.right
        anchors.topMargin: _chooseDate.anchors.topMargin
        height: _chooseDate.height
        width: height
        enabled: !isWindowOpen
        onClicked: {
            _cal_show.toNextDate()
            _taskList.loadTaskList()
            _madeTasks.loadTaskList()
        }
        style: ButtonStyle{
            background: Rectangle {
                // Окрашиваем фон кнопки
                color: _style.backgroundColor
                Image {
                    source: _style.isDarkTheme ? (control.pressed ? "Img/right_arrow_darkTheme_pressed.png" : "Img/right_arrow_darkTheme.png")
                                               : (control.pressed ? "Img/right_arrow_whiteTheme_pressed.png" : "Img/right_arrow_whiteTheme.png")
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.height - 12
                    height: width
                }
            }
        }
    }

    //Отделение верхней панели от списков задач
    Rectangle{
        id: horizontalLine
        anchors.bottom: _taskListRect.top
        width: parent.width
        height: 1
        color: _style.themeInvertedColor
        opacity: _style.disabledOpacity
    }

    //Список задач
    Rectangle{
        id: _taskListRect
        anchors.top: _chooseDate.bottom
        anchors.topMargin: _chooseDate.anchors.topMargin
        anchors.bottom:  panelButtons.top
        height: _mainWindow.height - _chooseDate.height -  panelButtons.height - _taskListRect.anchors.topMargin - _chooseDate.anchors.topMargin
        width: _mainWindow.width / 2
        color: _style.backgroundColor
        TaskList{
            id: _taskList
        }
    }

    //Список сделанных задач
    Rectangle{
        id: _madeTasksRect
        anchors.top: _chooseDate.bottom
        anchors.topMargin: _chooseDate.anchors.topMargin
        anchors.left: _taskListRect.right
        anchors.bottom:  panelButtons.top
        height: _mainWindow.height - _chooseDate.height -  panelButtons.height - _taskListRect.anchors.topMargin - _chooseDate.anchors.topMargin
        width: _mainWindow.width / 2
        color: _style.backgroundColor
        MadeTasks{
            id: _madeTasks
        }
    }

    //Разделение двух списков
    Rectangle{
        id: vertLine
        width: 0.5
        height: _taskListRect.height
        anchors.right: _taskListRect.right
        anchors.bottom: panelButtons.top
        color: _style.themeInvertedColor
        opacity: _style.disabledOpacity
    }

    Rectangle{
        id: vertLine_2
        width: 0.5
        height: _madeTasksRect.height
        anchors.left: _madeTasksRect.left
        anchors.bottom: panelButtons.top
        color: _style.themeInvertedColor
        opacity: _style.disabledOpacity
    }

    //Отделение списков от нижней панели
    Rectangle{
        id: panelButtonsHorizontalLine
        height: 1
        width: parent.width
        anchors.bottom: panelButtons.top
        color: _style.themeInvertedColor
        opacity: _style.disabledOpacity
    }

    //Нижняя панель
    Rectangle{
        id: panelButtons
        width: parent.width
        height: _chooseDate.anchors.topMargin * 2 + _chooseDate.height
        color: _style.backgroundColor
        anchors.bottom: parent.bottom
        //Кнопка добавления задачи
        Button {
            id: _addTask
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: parent.width * 10/192
            anchors.topMargin: (parent.height - height) / 2
            height: parent.height * 1/2
            width: height
            enabled: !isWindowOpen
            style: ButtonStyle{
                background: Rectangle {
                    // Окрашиваем фон кнопки
                    color: _style.backgroundColor
                    Image {
                        source: _style.isDarkTheme ? (control.pressed ? "Img/addTaskDarkPressed.png" : "Img/addTaskDark.png")
                                                   : (control.pressed ? "Img/addTaskWhitePressed.png" : "Img/addTaskWhite.png")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.height
                        height: width
                    }
                }

            }
            onClicked: {
                isWindowOpen = true
                _TaskDesc.isAdd = true
                _TaskDesc.openTaskDesc()
            }
        }
        //Кнопка выключения приложения
        Button{
            id: closeApp
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: parent.width * 10/192
            anchors.topMargin: (parent.height - height) / 2
            height: parent.height * 1/2
            width: height
            style: ButtonStyle{
                background: Rectangle {
                    // Окрашиваем фон кнопки
                    color: _style.backgroundColor
                    Image {
                        source: _style.isDarkTheme ? (control.pressed ? "Img/quitDarkPressed.png" : "Img/quitDark.png")
                                                   : (control.pressed ? "Img/quitWhitePressed.png" : "Img/quitWhite.png")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.height - 4
                        height: width
                    }
                }

            }
            onClicked: {
                Qt.quit()
            }
        }
        //Кнопка смены темы
        Button{
            id: switchTheme
            anchors.right: closeApp.left
            anchors.top: parent.top
            anchors.rightMargin: parent.width * 10/192
            anchors.topMargin: (parent.height - height) / 2
            height: parent.height * 1/2
            width: height
            style: ButtonStyle{
                background: Rectangle {
                    // Окрашиваем фон кнопки
                    color: _style.backgroundColor
                    Image {
                        source: _style.isDarkTheme ? (control.pressed ? "Img/switchThemeDarkPressed.png" : "Img/switchThemeDark.png")
                                                   : (control.pressed ? "Img/switchThemeWhitePressed.png" : "Img/switchThemeWhite.png")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.height
                        height: width
                    }
                }

            }
            onClicked: {
                _cal_show.switchTheme()
                _TaskDesc.switchTheme()
                _style.isDarkTheme = !_style.isDarkTheme
            }
        }
        /*Button{
            id: theGoals
            anchors.left: _addTask.right
            anchors.top: parent.top
            anchors.leftMargin: parent.width * 10/192
            anchors.topMargin: (parent.height - height) / 2
            height: parent.height * 1/2
            width: height
            style: ButtonStyle{
                background: Rectangle {
                    // Окрашиваем фон кнопки
                    color: _style.backgroundColor
                    Image {
                        source: _style.isDarkTheme ? (control.pressed ? "Img/goalsDarkPressed.png" : "Img/goalsDark.png")
                                                   : (control.pressed ? "Img/goalsWhitePressed.png" : "Img/goalsWhite.png")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.height
                        height: width
                    }
                }

            }
            onClicked: {
                console.log("Goals")
            }
        }*/
    }

    Component.onCompleted:{
        _madeTasks.loadTaskList()
        _taskList.loadTaskList()
    }
}
