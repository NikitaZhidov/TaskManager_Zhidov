import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4


Rectangle {

    id: root
    //Загрузка сделанных задач
    function loadTaskList(){
        dataModel.clear()
        var Tasks_M =
                helper.loadTaskList('m' + Qt.formatDate(tempDate, "dd.MM.yyyy"))
        var Desc_M =
                helper.loadDescList('m' + Qt.formatDate(tempDate, "dd.MM.yyyy"))
        for (var i = 0; i < Tasks_M.length; i++){
            dataModel.append({ taskName: Tasks_M[i],
                                 descTask: Desc_M[i]  })

        }
    }

    //Удаление сделанной задачи
    function deleteTask_m(index_t){
        helper.deleteTask(index_t, 'm' + Qt.formatDate(tempDate, "dd.MM.yyyy"))
        dataModel.remove(index_t)
    }

    //Вернуть задачу в исходный список
    function retTask(index_t){
        helper.madeTask(index_t, 'm' +  Qt.formatDate(tempDate, "dd.MM.yyyy"), 1)
    }

    ListModel {
        id: dataModel
    }

    Column {
        anchors.fill: parent
        spacing: _mainWindow.minimumWidth/ 2 / 48

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
            //Описание одного прямоугольника(задачи)
            delegate: Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: _style.secondaryOpacity
                width: view.width * 7/8
                height: _mainWindow.minimumWidth/ 2 / 48 + _mainWindow.minimumWidth/ 2 / 16 + _mainWindow.minimumWidth/ 2 / 48
                color: _style.backgroundColor
                border.color: _style.themeInvertedColor
                border.width: 0.5
                Button {
                    id: isCompleted
                    height: _mainWindow.minimumWidth/ 2 / 16
                    width: height
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: _mainWindow.minimumWidth/ 2 / 48
                    anchors.topMargin: _mainWindow.minimumWidth/ 2 / 48
                    style: ButtonStyle{
                        background: Rectangle{
                            border.color: _style.themeInvertedColor
                            color: _style.backgroundColor
                            Image{
                                height: isCompleted.height
                                width: height
                                source: "Img/checkMarkGreen.png"
                            }
                        }
                    }
                }

                Button {
                    id: deleteTaskButton
                    width: _mainWindow.minimumWidth/ 2 / 48
                    height: width
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: _mainWindow.minimumWidth/ 2 / 48
                    onClicked: {
                        deleteTask_m(index)
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
                    id: returnTaskButton
                    width: _mainWindow.minimumWidth/ 2 / 48
                    height: width
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: _mainWindow.minimumWidth/ 2 / 48
                    onClicked: {
                        retTask(index)
                        loadTaskList()
                        _taskList.loadTaskList()
                    }
                    style: ButtonStyle{
                        background: Rectangle{
                            color: _style.backgroundColor
                            Image{
                                source: _style.isDarkTheme ? (control.pressed ? "Img/retTaskDarkPressed.png" : "Img/retTaskDark.png")
                                                           : (control.pressed ? "Img/retTaskWhitePressed.png" : "Img/retTaskWhite.png")
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
