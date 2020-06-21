import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4


Rectangle {
    id: root

    property bool up: true
    property bool down: false

    //Загружаем список задач
    function loadTaskList(){
        dataModel.clear()
        var Tasks_M =
                helper.loadTaskList('n' + Qt.formatDate(tempDate, "dd.MM.yyyy"))
        var Desc_M =
                helper.loadDescList('n' + Qt.formatDate(tempDate, "dd.MM.yyyy"))
        for (var i = 0; i < Tasks_M.length; i++){
            dataModel.append({ taskName: Tasks_M[i],
                                 descTask: Desc_M[i]  })

        }
    }

    //Удаление задачи по индексу
    function deleteTask(index_t){
        helper.deleteTask(index_t,'n' +  Qt.formatDate(tempDate, "dd.MM.yyyy"))
        dataModel.remove(index_t)
    }

    //Изменение задачи
    function editTask(index_t){
        helper.editTask(index_t,'n' +  Qt.formatDate(tempDate, "dd.MM.yyyy"))
    }

    //Отметка задачи как сделанной
    function madeTask(index_t){
        helper.madeTask(index_t,'n' +  Qt.formatDate(tempDate, "dd.MM.yyyy"), 0)
    }

    ListModel {
        id: dataModel
    }

    Column {
        anchors.fill: parent
        spacing: view.width / 48

        ListView {
            id: view
            width: _taskListRect.width
            height: _taskListRect.height
            spacing: _mainWindow.minimumWidth/ 2 / 48
            model: dataModel
            clip: true
            header: Rectangle{
                height: view.spacing
            }
            footer: Rectangle{
                height: view.spacing
            }
            //Отображение одной задачи
            delegate: Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: view.width * 7/8
                height: _mainWindow.minimumWidth/ 2 / 48 + _mainWindow.minimumWidth/ 2 / 16 + _mainWindow.minimumWidth/ 2 / 48
                color: _style.backgroundColor
                border.color: _style.themeInvertedColor
                border.width: 0.5
                Button {
                    //Квадратик для отметки
                    id: isCompleted
                    height: _mainWindow.minimumWidth/ 2 / 16
                    width: height
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: _mainWindow.minimumWidth/ 2 / 48
                    anchors.topMargin: _mainWindow.minimumWidth/ 2 / 48
                    onClicked: {
                        madeTask(index)
                        loadTaskList()
                        _madeTasks.loadTaskList()
                    }
                    style: ButtonStyle{
                        background: Rectangle{
                            border.color: _style.themeInvertedColor
                            color: _style.backgroundColor
                            Image{
                                height: isCompleted.height
                                width: height
                                source: _style.isDarkTheme ? (control.pressed ? "Img/checkMarkDark.png" : "Img/empty.png")
                                                           : (control.pressed ? "Img/checkMarkWhite.png" : "Img/empty.png")
                            }
                        }
                    }
                }

                Button {
                    //Крестик для удаления
                    id: deleteTaskButton
                    width: _mainWindow.minimumWidth/ 2 / 48
                    height: width
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: _mainWindow.minimumWidth/ 2 / 48
                    enabled: !isWindowOpen
                    onClicked: {
                        deleteTask(index)
                    }
                    style: ButtonStyle{
                        background: Rectangle{
                            color: _style.backgroundColor
                            Image{
                                source: _style.isDarkTheme ? (control.pressed ? "Img/closeIconDarkPressed.png" : "Img/closeIconDark.png")
                                                           : (control.pressed ? "Img/closeIconWhitePressed.png" : "Img/closeIconWhite.png")
                                width: parent.width
                                height: width
                            }

                        }
                    }
                }

                Button {
                    //Кнопка изменения задачи
                    id: editTaskButton
                    width: _mainWindow.minimumWidth/ 2 / 48
                    height: width
                    anchors.right: deleteTaskButton.left
                    anchors.top: parent.top
                    anchors.margins: _mainWindow.minimumWidth/ 2 / 48
                    enabled: !isWindowOpen
                    onClicked: {
                        isWindowOpen = true
                        _TaskDesc.openEditTaskDesc(taskName, descTask, index)
                    }
                    style: ButtonStyle{
                        background: Rectangle{
                            color: _style.backgroundColor
                            Image{
                                source: _style.isDarkTheme ? (control.pressed ? "Img/editIconDarkPressed.png" : "Img/editIconDark.png")
                                                           : (control.pressed ? "Img/editIconWhitePressed.png" : "Img/editIconWhite.png")
                                width: parent.width
                                height: width
                            }
                        }
                    }
                }

                Button {
                    //Перемещение вверх
                    id: upTaskButton
                    width: (index === 0) ? 0 : _mainWindow.minimumWidth/ 2 / 48
                    height: width
                    anchors.right: editTaskButton.left
                    anchors.top: parent.top
                    anchors.margins: _mainWindow.minimumWidth/ 2 / 48
                    enabled: !isWindowOpen
                    onClicked: {
                        helper.moveTask(index, 'n' +  Qt.formatDate(tempDate, "dd.MM.yyyy"), up)
                        loadTaskList()
                    }
                    style: ButtonStyle{
                        background: Rectangle{
                            color: _style.backgroundColor
                            Image{
                                source: _style.isDarkTheme ? (control.pressed ? "Img/upDarkPressed.png" : "Img/upDark.png")
                                                           : (control.pressed ? "Img/upWhitePressed.png" : "Img/upWhite.png")
                                width: parent.width
                                height: width
                            }
                        }
                    }
                }

                Button {
                    //Перемещение вниз
                    id: downTaskButton
                    width: (index === dataModel.count - 1) ? 0 : _mainWindow.minimumWidth/ 2 / 48
                    height: width
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: _mainWindow.minimumWidth/ 2 / 48
                    anchors.rightMargin: _mainWindow.minimumWidth * 5 / 2 / 48
                    enabled: !isWindowOpen
                    onClicked: {
                        helper.moveTask(index, 'n' +  Qt.formatDate(tempDate, "dd.MM.yyyy"), down)
                        loadTaskList()
                    }
                    style: ButtonStyle{
                        background: Rectangle{
                            color: _style.backgroundColor
                            Image{
                                source: _style.isDarkTheme ? (control.pressed ? "Img/downDarkPressed.png" : "Img/downDark.png")
                                                           : (control.pressed ? "Img/downWhitePressed.png" : "Img/downWhite.png")
                                width: parent.width
                                height: width
                            }
                        }
                    }
                }

                Text {
                    id: _nameText
                    anchors.left: isCompleted.right
                    anchors.top: parent.top
                    font.pixelSize: _mainWindow.minimumWidth/ 2 / 28
                    font.bold: true
                    anchors.leftMargin: _mainWindow.minimumWidth/ 2 / 48
                    anchors.topMargin: _mainWindow.minimumWidth/ 2 / 2 / 48
                    renderType: Text.NativeRendering
                    color: _style.themeInvertedColor
                    text: taskName
                }
                Text {
                    id: _descriptionText
                    anchors.left: isCompleted.right
                    anchors.top: _nameText.bottom
                    font.pixelSize: _nameText.font.pixelSize * 10/15
                    anchors.leftMargin: _mainWindow.minimumWidth/ 2 / 48
                    anchors.topMargin: _mainWindow.minimumWidth/ 2 / 2 / 2 / 48
                    color: _style.themeInvertedColor
                    opacity: _style.secondaryOpacity
                    text: descTask
                }
            }
        }
    }
}
