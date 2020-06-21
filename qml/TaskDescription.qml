import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.12

Item {
    //Отображение окна добавления или изменения задачи

    id: root

    Style{
        id: _style
    }

    property bool isAdd: true
    property int current_index: -1
    property int previousX
    property int previousY

    //Открываем окно изменения задачи
    function openEditTaskDesc(taskName_c, DescTask_c, index_t){
        dialogRoot.visible = true
        inputTaskName.text = taskName_c
        inputDescTask.text = DescTask_c
        isAdd = false
        current_index = index_t
    }

    //Открываем окно добавления задачи
    function openTaskDesc(){
        dialogRoot.visible = true
    }

    //Очищаем поля
    function clearTextAreas(){
        inputTaskName.text = ""
        inputDescTask.text = ""
    }

    //Смена темы
    function switchTheme(){
        _style.isDarkTheme = !_style.isDarkTheme
    }

    Window{
        //Возможность передвигать окно
        flags: Qt.FramelessWindowHint

        MouseArea {
            id: topArea
            height: 25
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            onPressed: {
                previousX = mouseX
                previousY = mouseY
            }

            onMouseXChanged: {
                var dx = mouseX - previousX
                dialogRoot.setX(dialogRoot.x + dx)
            }

            onMouseYChanged: {
                var dy = mouseY - previousY
                dialogRoot.setY(dialogRoot.y + dy)
            }
        }


        //Само окно
        id: dialogRoot
        width: Screen.desktopAvailableWidth / 4
        height: Screen.desktopAvailableHeight / 4
        maximumHeight: height
        minimumHeight: height
        maximumWidth: width
        minimumWidth: width
        color: _style.themeOpacityColor
        title: isAdd ? "Описание задачи" : "Изменение задачи"
        //Фон окна
        Rectangle{
            id: dialogTask
            anchors.fill: parent
            width: parent.width
            height: parent.height
            color: _style.themeOpacityColor
            Label{
                id: taskNameEnterText
                anchors.top: parent.top
                anchors.topMargin: parent.height / 15
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 14/15

                Text {
                    text: "Имя задачи"
                    anchors.left: parent.left
                    color: _style.themeInvertedColor
                    font.bold: true
                    font.pixelSize: parent.width / 28
                }
            }

            //Имя задачи
            Rectangle{
                id: taskName
                anchors.top: taskNameEnterText.bottom
                anchors.topMargin: parent.height / 25
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 14/15
                height: parent.height / 7
                color: _style.backgroundColor
                border.width: 0.5
                border.color: _style.themeInvertedColor
                TextInput{
                    id: inputTaskName
                    anchors.fill: parent
                    anchors.leftMargin: parent.border.width * 6
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    color: _style.themeInvertedColor
                    font.pixelSize: parent.width / 28
                    maximumLength: 25

                    wrapMode: Text.WordWrap
                    focus: true
                    selectByMouse: true

                }
            }

            Label{
                id: taskDescEnterText
                anchors.top: taskName.bottom
                anchors.topMargin: parent.height / 25
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 14/15

                Text {
                    text: "Краткое описание задачи"
                    anchors.left: parent.left
                    color: _style.themeInvertedColor
                    font.bold: true
                    font.pixelSize: parent.width / 28
                }
            }

            //Описание задачи
            Rectangle{
                id: descTask
                anchors.top: taskDescEnterText.bottom
                anchors.topMargin: parent.height / 25
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 14/15
                height: parent.height / 3

                color: _style.backgroundColor
                border.width: 0.5
                border.color: _style.themeInvertedColor

                TextInput{
                    id: inputDescTask
                    width: parent.width
                    anchors.fill: parent
                    anchors.leftMargin: parent.border.width * 6
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                    color: _style.themeInvertedColor
                    font.pixelSize: parent.width / 28

                    wrapMode: Text.WordWrap
                    maximumLength: 45
                    focus: true
                    selectByMouse: true
                }

                Text {
                    id: _charLeft
                    text: inputDescTask.maximumLength - inputDescTask.length
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.rightMargin: 3
                    anchors.bottomMargin: 3
                    font.pixelSize: 12
                    color: _style.themeInvertedColor
                    opacity: _style.secondaryOpacity

                }
            }

            Row {
                id: row
                height: parent.height / 8
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                // Кнопка для закрытия диалога
                Button {
                    id: dialogButtonCalCancel
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width / 2 - 1

                    style: ButtonStyle {
                        background: Rectangle {
                            color: _style.themeInvertedColor
                            opacity: control.pressed ? _style.disabledOpacity : 0.6
                            border.width: 0
                        }

                        label: Text {
                            text: qsTr("Отмена")
                            font.pixelSize: 14
                            color: _style.themeDefaultColor
                            opacity: control.pressed ? _style.secondaryOpacity : 1
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                    // По нажатию на кнопку - просто закрываем диалог
                    onClicked:{
                        isWindowOpen = false
                        clearTextAreas()
                        dialogRoot.visible = false
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

                // Кнопка подтверждения добавленной задачи
                Button {
                    id: dialogButtonCalOk
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width / 2 - 1

                    style: ButtonStyle {
                        background: Rectangle {
                            color: _style.themeInvertedColor
                            opacity: control.pressed ? _style.disabledOpacity : 0.6
                            border.width: 0
                        }

                        label: Text {
                            text: isAdd ? "Добавить" : "Изменить"
                            font.pixelSize: 14
                            color: _style.themeDefaultColor
                            opacity: control.pressed ? _style.secondaryOpacity : 1
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                    //По клику изменяем или добавляем задачу
                    onClicked:
                    {
                        if (isAdd){
                            dialogRoot.visible = false
                            helper.makeTask('n' + Qt.formatDate(tempDate, "dd.MM.yyyy"), inputTaskName.text, inputDescTask.text)
                            _taskList.loadTaskList()
                            clearTextAreas()
                            isWindowOpen = false
                        } else{
                            dialogRoot.visible = false
                            helper.editTask(current_index, 'n' + Qt.formatDate(tempDate, "dd.MM.yyyy"), inputTaskName.text, inputDescTask.text)
                            _taskList.loadTaskList()
                            clearTextAreas()
                            isWindowOpen = false
                        }
                    }

                }
            }
        }
    }
}
