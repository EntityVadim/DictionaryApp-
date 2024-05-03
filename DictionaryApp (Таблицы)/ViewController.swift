import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionHeaderHeight = 32
    }
    
    let words = [
        ["Apple", "Pear", "Watermelon"],
        ["Carrot", "Pickle", "Potato", "Tomato"],
        ["Strawberry", "Raspberry", "Blackberry", "Blueberry"]
    ]
    let headers = ["Fruits", "Vegetables", "Berries"]
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let vegOrFruitArray = words[section] // получили массив по номеру секции
        return vegOrFruitArray.count         // вернули количество элементов в нём
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell                                                   // 1
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: "cell") { // 2
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")        // 3
        }
        var content = cell.defaultContentConfiguration()
        content.text = words[indexPath.section][indexPath.row]
        //cell.textLabel?.text = words[indexPath.row]                               // 4
        cell.contentConfiguration = content
        return cell                                                                 // 5
    }
    /*Давайте разберём этот код:
     1. Мы создаём пока не инициализированную константу cell. В неё сохраним ячейку, которую будем настраивать и
     возвращать таблице.
     
     2. Затем нам нужно вызывать метод dequeueReusableCell(withIdentifier:), чтобы получить из него
     переиспользованную ячейку. О механизме переиспользования мы поговорим уже на следующем уроке, а пока
     запомните следующее: система не создаст новую ячейку, если можно переиспользовать одну из существующих. Это
     делается для экономии, ведь если много ячеек — много и потребляемой памяти. Если такая ячейка есть, мы
     сохраняем её в нашу константу cell. Обратите внимание: здесь мы передали тот же идентификатор, который
     установили для ячейки в сториборде.
     
     3. Если же по каким-либо причинам переиспользовать ячейку не удалось, и метод
     dequeueReusableCell(withIdentifier:) вернул nil— например, если в сториборде неверно указан идентификатор
     для ячейки, — то мы создадим новую ячейку. Вот так:
     
     UITableViewCell(style: .default, reuseIdentifier: "cell") // 3
     
     Мы делаем её стандартного вида и задаём ей идентификатор cell.
     
     4. Здесь мы устанавливаем в textLabel текст, который должен быть у ячейки. XCode тут может отобразить
     предупреждение (warning) о том, что использование textLabel устарело и что сейчас нужно использовать
     UIListContentConfigurator. Но UIListContentConfigurator был введён в iOS 14 и не работает на версиях iOS
     ниже 14-й. Поэтому мы пока не будем пользоваться этим методом, а будем использовать textLabel.
     5.  Ну вот и всё — ячейка настроена, можно отдавать её таблице!
     
     Обратите внимание:
     – Метод tableView(_:numberOfRowsInSection:) будет вызван для каждой секции.
     Так как у нас всего одна секция, то он и вызовется один раз.
     Метод cellForRowAt будет вызван для каждой ячейки. То есть какое число мы
     передали в tableView(_:numberOfRowsInSection:), столько раз
     tableView(_:cellForRowAt:) и будет вызван.*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(
            title: nil,
            message: "Вы нажали на: \(words[indexPath.section][indexPath.row])",
            preferredStyle: .alert)                                                // 1
        let okAction = UIAlertAction(
            title: "OK",
            style: .default) { _ in                                                // 2
                alert.dismiss(animated: true)                                      // 3
            }
        alert.addAction(okAction)                                                  // 4
        present(alert, animated: true)                                             // 5
    }
    /*Давайте разберём этот код:
     1. Мы создаём алерт и в нём отображаем слово, на которое нажмёт пользователь. Это слово мы получаем из
     массива words по номеру секции и номеру элемента в этой секции:
     
     words[indexPath.section][indexPath.row]
     
     2. Создаём кнопку «OK».
     3. В handler кнопки, нажимая на неё, мы закрываем алерт. При этом не указываем параметр явно: если
     замыкание — последний параметр функции, то  его название можно опустить. Это просто синтаксический сахар,
     как если бы мы написали:
     
     let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in             /
     alert.dismiss(animated: true)
     })
     
     4. Добавляем нашу кнопку в алерт.
     5. Отображаем алерт.*/
}
