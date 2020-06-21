#include "helper.h"
#include <QDebug>
#include <QDir>
#include <QFile>
#include <QTextCodec>

Helper::Helper(QObject *parent) : QObject(parent)
{

}

// Загрузка задач из файла
QVector<QString> Helper::loadTaskList(QString Date)
{

    QFile f("./Task_Base.txt");
    QVector<QString> TaskList;
    if (!f.open(QIODevice::ReadWrite))
        return TaskList;

    QTextStream in(&f);

    in.setCodec("UTF-8");

    QString currentline;
    QString word;

    //Формируем QVector из названий задач и возвращаем

    while(!in.atEnd()){
        currentline = f.readLine();
        if(!currentline.isEmpty() && !currentline[0].isSpace()){
            word = currentline.simplified();
        }
        else if (word == Date && currentline.simplified()[0] != '-' && !(currentline == "\n") ) {
            TaskList.push_back(currentline.simplified());
        }
    }

    f.close();
    return TaskList;
}

//Запись задачи в конец файла
QVector<QString> Helper::makeTask(QString Date, QString taskName, QString descTask)
{

    QFile f("./Task_Base.txt");
    QVector<QString> TaskList;
    if (!f.open(QIODevice::ReadOnly | QIODevice::Append))
        return TaskList;

    while (taskName.simplified()[0] == '-'){
        taskName = taskName.simplified();
        taskName[0] = ' ';
        taskName = taskName.simplified();
    }

    QTextStream in(&f);

    in.setCodec("UTF-8");

    //Описание задачи начинается с '-', чтобы отличать от названия

    QString newTask = "\n" + Date + "\n\t" + taskName + "\n -" + descTask;

    f.write(newTask.toStdString().c_str());

    f.close();
    return TaskList;
}

//Загрузка описаний задач из файла
QVector<QString> Helper::loadDescList(QString Date)
{

    QFile f("./Task_Base.txt");
    QVector<QString> DescList;
    if (!f.open(QIODevice::ReadWrite))
        return DescList;

    QTextStream in(&f);

    in.setCodec("UTF-8");

    QString currentline;
    QString currentline_simp;
    QString word;

    //Загрузка по аналогии как с задачами

    while(!in.atEnd()){
        currentline = f.readLine();
        currentline_simp = currentline.simplified();
        if(!currentline.isEmpty() && !currentline[0].isSpace()){
            word = currentline_simp;
        }
        else if (word == Date && currentline_simp[0] == '-') {
            //удаление 1го символа
            currentline_simp[0] = ' ';
            DescList.push_back(currentline_simp.simplified());
        }
    }

    f.close();
    return DescList;

}

//Удаление задачи в файле
void Helper::deleteTask(int index, QString Date)
{

    QFile f("./Task_Base.txt");
    if (!f.open(QIODevice::ReadWrite))
        return;

    QString currentline;
    QString save_lines;
    QString word;
    QTextStream t(&f);

    t.setCodec("UTF-8");

    //индекс
    int i = -1;

    //Сохраняем все строки в save_lines кроме удалённой
    //Обнуляем Task_Base.txt и записываем в него save_lines

    while(!t.atEnd()){
        currentline = f.readLine();
        if(!currentline.isEmpty() && !currentline[0].isSpace()){
            word = currentline.simplified();
            if (word == Date){
                i++;
            }
            if (i != index || word != Date){
                save_lines.append(currentline);
            }
        }
        else if (i != index || word != Date){
            save_lines.append(currentline);
        }
    }
    f.resize(0);
    t << save_lines;
    f.close();
    return;

}

//Редактирование задачи в файле
void Helper::editTask(int index, QString Date, QString taskName, QString descTask)
{

    QFile f("./Task_Base.txt");
    if (!f.open(QIODevice::ReadWrite))
        return;

    QString currentline;
    QString save_lines;
    QString word;
    QTextStream t(&f);

    while (taskName.simplified()[0] == '-'){
        taskName = taskName.simplified();
        taskName[0] = ' ';
        taskName = taskName.simplified();
    }

    taskName = "\t" + taskName + "\n";
    descTask = " -" + descTask + "\n";

    //индекс
    int i = -1;

    t.setCodec("UTF-8");

    //Редактирование по аналогии как и с удалением
    //Только вместо удаленных записываем отредактированные

    while(!t.atEnd()){
        currentline = f.readLine();
        if(!currentline.isEmpty() && !currentline[0].isSpace()){
            word = currentline.simplified();
            if (word == Date){
                i++;
            }
            save_lines.append(currentline);
            continue;
        }else if (currentline[0] == "\n"){
            continue;
        }
        else if (i != index || word != Date){
            save_lines.append(currentline);
            continue;
        }
        if(currentline.simplified()[0] != '-'){
            save_lines.append(taskName);
        }
        else{
            save_lines.append(descTask);
        }

    }
    f.resize(0);
    t << save_lines;
    f.close();
    return;
}

//Отметка сделанной задачи в файле
void Helper::madeTask(int index, QString Date, bool isMade)
{
    QFile f("./Task_Base.txt");
    if (!f.open(QIODevice::ReadWrite))
        return;

    QString currentline;
    QString madeData;

    /* В зависимости от того сделана задача или нет
     * определяем отметить как сделанную или вернуть
     * в исходный список задач */
    if (isMade)
        madeData = "n";
    else
        madeData = "m";

    QString word;
    QTextStream t(&f);

    //индекс
    int i = -1;

    t.setCodec("UTF-8");

    /*Меняем первую букву, которая определяет тип задачи
     * (сделана или нет) */


    while(!t.atEnd()){
        currentline = f.readLine();
        if(!currentline.isEmpty() && !currentline[0].isSpace()){
            word = currentline.simplified();
            if (word == Date){
                i++;
            }
            if (i == index && word == Date){
                f.seek(f.pos()- currentline.length());
                f.write(madeData.toStdString().c_str());
                break;
            }
        }
    }

    f.close();
    return;
}

//Изменение положения задачи в файле
void Helper::moveTask(int index, QString Date, bool direction)
{
    QFile f("./Task_Base.txt");
    if (!f.open(QIODevice::ReadWrite))
        return;

    QString currentline;
    QString save_lines;
    QString buf_save_lines;

    int direction_move = 0;

    /* В зависимости от перемещения задачи(вверх или вниз)
     * определяем индекс перемещаемой задачи */
    if(direction)
        direction_move = -1;
    else
        direction_move = 0;

    QString word;
    QTextStream t(&f);

    //индекс
    int i = -1;

    t.setCodec("UTF-8");

    /* Сохраняем перещаемую задачу в буфер
     * затем записываем после отмеченной (index) */

    while(!t.atEnd()){
        currentline = f.readLine();
        if(!currentline.isEmpty() && !currentline[0].isSpace()){
            word = currentline.simplified();
            if (word == Date){
                i++;
            }
            if ((i == index + direction_move) && word == Date){
                buf_save_lines.append(currentline);
                continue;
            }
            save_lines.append(currentline);
            continue;
        }else if (currentline[0] == "\n"){
            continue;
        }else if (i == index + direction_move + 1 && word == Date){
            save_lines.append(currentline);
            if (currentline[currentline.size()] != "\n")
                save_lines.append("\n");
            if (currentline.simplified()[0] == "-"){
                save_lines.append(buf_save_lines);
            }
            continue;
        }
        else if ( i != index + direction_move || word != Date){
            save_lines.append(currentline);
            continue;
        }
        else if (i == index + direction_move && word == Date){
            buf_save_lines.append(currentline);
            continue;
        }
        save_lines.append(currentline);

    }
    f.resize(0);
    t << save_lines;
    f.close();
    return;
}
