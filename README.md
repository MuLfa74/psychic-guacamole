# Чат-интерфейс с ИИ "ChatInt"

Проект для технологического конкурса "Умные мобильные решения: сенсорика, искусственный интеллект и интернет-взаимодействие".
Задача реализовать чат-интерфейс с ИИ (прим. GigaChat).
Хранение истории чата будет локальным в устройстве.

## Flutter

Флаттер был выбран в качестве кросс-платформенного языка для платформ Android и устройств с ОС "Аврора".

## Модели

Предполагается в проекте выбор модели, но пока за неимением других вариантов, кроме GigaChat, будет реализован только оный

### **/GigaChat**
ИИ помощник от Сбера, предоставляющий 1млн бесплатных токенов, а также полностью русскую документацию с удобными гайдами.

# Известные проблемы

- ### ~~Не загружается `.env` файл~~ (решено)
Пока не ясно с чем связана проблема, потому в тестовой ветке создан костыль (не скажу какой)

- ### ~~Нет доверия в клиенте~~ (решено)
`(HandshakeException: Handshake error in client (OS Error: СERTIFICATE_VERIFY_FAILED...` <br/>
Пока решен костылем в тестовой ветке с собственным httpClient (также небезопасно)

# Предотчеты

- ### v1.0
[Демо оболочки без внедрения API](https://youtu.be/k8lhKYUM1Cc) <br/>
Сама API работает, запросы доходят до GigaChat (см. скрин ниже) <br/>
<a href="https://ibb.co/4Z5xtWsc"><img src="https://i.ibb.co/SX9pyNQ2/photo-2025-06-02-14-44-45.jpg" alt="photo-2025-06-02-14-44-45" border="0"></a>
- ### v2.0
API привязана к оболочке, модель отвечает в чате, история сохраняется (см. скрины ниже). Текст пока без форматирования.<br/>
<a href="https://imgbb.com/"><img src="https://i.ibb.co/wFVCZ3PF/photo-2025-06-02-21-23-53.jpg" alt="photo-2025-06-02-21-23-53" border="0"></a> <br/>
<a href="https://imgbb.com/"><img src="https://i.ibb.co/HwtvKzz/photo-2025-06-02-21-25-30.jpg" alt="photo-2025-06-02-21-25-30" border="0"></a> <br/>
<a href="https://imgbb.com/"><img src="https://i.ibb.co/bgV4KS19/photo-2025-06-02-21-26-25.jpg" alt="photo-2025-06-02-21-26-25" border="0"></a>
- ### v2.1
Реализовано markdown-форматирование текста в чате (с помощью пакета `flutter_markdown`) <br/>
<a href="https://imgbb.com/"><img src="https://i.ibb.co/x8cn35Xg/photo-2025-06-02-21-53-25.jpg" alt="photo-2025-06-02-21-53-25" border="0"></a>
- ### v2.2
Подключено интернет соединение в релизной версии, из-за чего само приложение ранее не работало)))))<br/>
Встроен сертификат с госуслуг и клиент теперь норм<br/>
Убрано небезопасное подключение кое-чего<br/>
