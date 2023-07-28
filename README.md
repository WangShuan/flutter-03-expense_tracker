# expense_tracker

該專案主要架構有一個 Appbar ，裏面顯示 app 標題以及 icon 按鈕，點擊 icon 按鈕後可開啟 modal 以新增消費紀錄； Appbar 下方則顯示圖表，分別列出每種類別的消費佔比；最後圖表下方則是列出所有消費紀錄的清單，其中有消費類別、標題、消費日期以及消費金額。

## 重點紀錄

### 定義 Expense 藍圖

`uuid` 套件可用來生成隨機的唯一 id，可通過指令 `flutter pub add uuid` 安裝套件，使用方式如下：

```dart
// 引入套件
import 'package:uuid/uuid.dart';

class Expense { // 創建 Expense 藍圖，方便後續生成 Expense 列表
  Expense({
    required this.title,
    required this.price,
    required this.date,
  }) : id = Uuid().v4(); // 用 : id = xxx 設定初始值，並將初始值設為 Uuid().v4()

  final String id;
  final String title;
  final int price;
  final DateTime date;
}
```

`enum` 用來定義一個類別以及該類別中可用的內容，舉例如下：

```dart
// 建立一個類別 Category 並設置其可用的內容
enum Category { 
  food,
  shopping,
  medical,
  learn,
}

// 指定 category 的類別為 Category 
// 所以 category 的值被限定為 food/shopping/medical/learn 四者其一
final Category category; 
```

定義與使用 category 的 icon ：

```dart
// 在 model/expense.dart 中定義 cateIcon 為各自類型所對應的 Icons
const cateIcon = {
  Category.food: Icons.restaurant,
  Category.learn: Icons.menu_book,
  Category.medical: Icons.medical_services,
  Category.shopping: Icons.store
};

// 使用 Icons
CircleAvatar(
  child: Icon(
    cateIcon[expenseData.category],
  ),
)
```

第三方套件 `intl` 用來格式化日期，可通過指令 `flutter pub add intl` 進行安裝，用法如下：

```dart
// 通過 DateFormat() 設置想要顯示的格式，再用 format(date) 傳入 date 進行格式化
get formatterTime {
  return DateFormat('yyyy-MM-dd').format(date);
}
```

### 認識與使用新的小部件

`ListView` 小部件，需搭配 `Expanded` 使用：

```dart
final List<Expense> expenseData;

Expanded(
  child: ListView.builder( // 使用 ListView.builder 小部件
    itemBuilder: (context, index) => Row( // 傳入 itemBuilder
      children: [
        Text(expenseData[index].title), // 通過 index 獲取 expenseData 中的內容
      ],
    ),
    itemCount: expenseData.length, // 設置 itemCount 為 expenseData 的長度
  ),
)
```

使用 `modal` 小部件顯示表單，用以新增消費紀錄：

```dart
appBar: AppBar( // 在 Scaffold 小部件中設置 appbar
  title: const Text('Expenses Tracker'),  // 設定 title
  actions: [ // 設定工具列的按鈕
    IconButton( // 建立一個純 icon 的按鈕
      onPressed: () { // 設定點擊後觸發的事件
        showModalBottomSheet( // 這邊使用 showModalBottomSheet 開啟一個 modal
          context: context, // 傳入 context
          builder: (ctx) => const NewExpense(), // 設置 builder 回傳一個自定義的 NewExpense 表單小部件
        );
      },
      icon: const Icon( // 設置 icon
        Icons.add,
      ),
    ),
  ],
),
```

表單的輸入框要用 `TextField` 小部件，為了獲取輸入的內容，需設定小部件的 `controller` 屬性，並使用 `dispose()` 方法確保當關閉 `modal` 時同時銷毀控制器：

```dart
final _titleController = TextEditingController(); // 建立輸入框控制器

@override
void dispose() { // 使用 dispose() 方法
  _titleController.dispose(); // 在不需要使用到 UI 時銷毀該控制器，以確保不會佔用到多餘的內存
  super.dispose();
}

// 綁定輸入框的控制器
TextField(
  controller: _titleController, // 綁定 controller
  decoration: const InputDecoration( // 設置樣式
    label: Text('標題'), // 設置 label
  ),
  maxLength: 30, // 設置輸入內容的最大長度限制
),

// 獲取值
print(_titleController.text);
```

另外在使用 `TextField` 時要注意，如果父部件為 `Row` 或 `Column`，需將 `TextField` 用 `Expanded` 小部件包住，否則會出現錯誤：

```dart
Row(
  children: [
    Expanded(
      child: TextField(
        controller: _priceController,
        decoration: const InputDecoration(
          label: Text('價格'),
          prefixText: 'NT\$ ', // 這邊是用來設定輸入框值的前綴，這樣在輸入價格時可以看到數字前面多了  NT$
        ),
        maxLength: 10,
        keyboardType: TextInputType.number,
      ),
    ),
    const SizedBox(
      width: 30,
    ),
    ElevatedButton(
      onPressed: () {},
      child: const Text('請選擇日期'),
    ),
  ],
),
```

點擊按鈕關閉 `modal` 的方法：

```dart
ElevatedButton(
  onPressed: () {
    Navigator.pop(context); // 設定這行用來關閉 modal
  },
  child: const Text('CANCEL'),
)
```

點擊按鈕開啟日期選擇器及顯示選中日期的做法：

```dart
DateTime? _selectedDate_; // 聲明一個變量保存選中的日期，類型為 null 或 DateTime

void _chooseDate() async { // 設定開啟日期選擇器的事件
  final d = await showDatePicker( // 通過 await 方法獲取選中的日期，通過 showDatePicker 方法開啟日期選擇器
    context: context, // 傳入 context
    initialDate: DateTime.now(), // 設置預設選中的日期
    firstDate: DateTime(2000), // 設置最小日期
    lastDate: DateTime.now(), // 設置最大日期
  );
  setState(() { // 通過 setState 更新日期並顯示在畫面上
    _selectedDate_ = d;
  });
}

// 使用
ElevatedButton.icon( // 建立一個帶 icon 的按鈕小部件
  onPressed: _chooseDate, // 設置點擊後觸發的事件為 開啟日期選擇器的事件
  label: _selectedDate_ != null // 判斷是否有選中日期，有就顯示選中的日期，沒有就顯示請選擇
      ? Text(DateFormat('yyyy-MM-dd') // 用 intl 套件格式化日期
          .format(_selectedDate_!) // 在可能為空的值後加上 ! 告訴 DART 這永遠不會是空值
          .toString())
      : const Text('請選擇日期'),
  icon: const Icon( // 設置 icon
    Icons.calendar_today,
    size: 15,
  ),
),
```

類別下拉選項小部件：

```dart
// 宣告變量 _selectCate 為第一個 Category
Category? _selectCate = Category.values[0];

// 使用
Container( // 建立 Container 小部件當外框並設定樣式
  padding: const EdgeInsets.symmetric(
    horizontal: 15, // 設定水平的 padding
  ),
  height: 40, // 設定高度
  width: 120, // 設定寬度
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10), // 設定圓角弧度
    color: const Color.fromARGB(255, 240, 230, 250), // 設定底色
  ),
  child: DropdownButton<Category>( // 使用 DropdownButton 小部件生成下拉選單
    underline: const SizedBox(), // 設置下拉選單的外觀樣式
    isExpanded: true, // 設置擴展為 true（前提是父部件有設定寬度）
    items: Category.values // 設定下拉選項內容，這邊用 Category.values 遍歷
        .map(
          (e) => DropdownMenuItem<Category>( // 回傳 DropdownMenuItem 小部件
            value: e, // 設定選項的 value
            child: Row( // 設定 DropdownMenuItem 小部件的內容
              children: [
                Icon(
                  cateIcon[e],
                  size: 18,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  cateZhName[e].toString(),
                  style: textStyle,
                ),
              ],
            ),
          ),
        )
        .toList(), // 最後用 toList() 轉為 [ DropdownMenuItem(), DropdownMenuItem()... ]
    value: _selectCate, // 設定選中的選項
    icon: const Icon(
      Icons.arrow_drop_down_rounded,
      size: 15,
    ),
    onChanged: (value) { // 每次選中項目時觸發 onChanged，並會傳入 DropdownMenuItem 的 value
      setState(() { // 將選中的狀態設為 value
        _selectCate = value;
      });
    },
  ),
)
```

驗證表單並提交：

```dart
void _submitData() { // 建立一個提交表單用的事件
  if (_titleController.text.trim().isEmpty || // 判斷去除多餘空白後，是否有輸入標題
      _priceController.text.trim().isEmpty || // 判斷去除多餘空白後，是否有輸入價格
      int.parse(_priceController.text) <= 0 || // 判斷將文字轉為數字後是否有內容且小於等於零
      _selectedDate == null) { // 判斷是否有選擇日期
    showDialog( // 顯示對話框
      context: context,
      builder: (context) => AlertDialog( // 顯示警告對話框小部件
        title: const Text('格式錯誤'), // 設定標題
        content: const Text('請確保您輸入了有效的標題、消費價格、消費日期與消費類別。'), // 設置警告內容
        actions: [
          TextButton( // 設置功能按鈕
            onPressed: () {
              Navigator.pop(context); // 點擊後關閉對話框
            },
            child: const Text('確定'),
          )
        ],
      ),
    );
    return; // 返回，不執行下方程式碼
  }
  
  // 如果上方驗證沒問題則觸發以下程式碼
  widget.addData(Expense( // 這邊的 addData 是從 expenses.dart 傳入的，用來新增消費紀錄資料
    title: _titleController.text.trim(),
    price: int.parse(_priceController.text),
    date: _selectedDate!,
    category: _selectCate!,
  ));
  Navigator.pop(context); // 新增後關閉 modal
}
```

優化 `modal` 讓鍵盤不會擋到內容的兩種方法：

第一種，讓 `modal` 佔據完整可用高度，程式碼如下：

```dart
showModalBottomSheet(
  context: context,
  builder: (ctx) => NewExpense(_addData),
  isScrollControlled: true, // 新增這個設定，讓 modal 佔據完整的可用高度
);
```

> 當 `modal` 佔據完整可用高度後，會發現部分內容將被手機本身的手機本身的功能遮蓋，比如相機鏡頭等等，所以需要讓 `modal` 的 `padding-top` 預留多一些空間，以確保能完整瀏覽 `modal` 的內容。

第二種，通過 `MediaQuery.of(context).viewInsets.bottom` 獲取鍵盤高度，並利用 `padding-bottom` 讓 `modal` 的內容往上推，程式碼如下：

```dart
showModalBottomSheet(
  context: context,
  builder: (ctx) => Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom, // 設置 paddint-bottom 為鍵盤高度
    ),
    child: NewExpense(_addData),
  ),
  isScrollControlled: true,
);
```

左/右滑動觸發事件可使用 `Dismissible` 小部件來實現，以本例來說，可通過滑掉單筆消費紀錄將該筆紀錄刪除：

```dart
void removeExpenses(Expense expense) {
  setState(() {
    expensesData.remove(expense);
  });
}

Dismissible(
  key: ValueKey(expenseData[i].id), // 設置唯一 key
  child: ExpenseItem(
    expenseData[i],
  ),
  onDismissed: (direction) => removeExpenses(expenseData[i]), // 設置滑動後要執行的事件
)
```

於刪除事件後產生提示訊息，可用 `SnackBar` 小部件：

```dart
ScaffoldMessenger.of(context).clearSnackBars(); // 再產生新的 SnackBar 之前先清除舊的
ScaffoldMessenger.of(context).showSnackBar( // 顯示一個 SnackBar
  SnackBar( // 傳入 SnackBar 小部件
    content: Text('已刪除 ${expense.title} 消費。'), // 設置訊息內容
    duration: const Duration(seconds: 3), // 設置顯示時長，三秒後會自動消失
    action: SnackBarAction( // 設置按鈕
        label: '復原', // 按鈕名稱
        onPressed: () { // 點擊後執行的事件
          setState(() {
            expensesData.add(expense);
          });
        }),
  ),
);
```

## 自定義主題樣式

可設定使用 Material V3 版本的主題（默認是 V2 版本的主題，即主色為藍色的那種）

```dart
MaterialApp(
  theme: ThemeData(useMaterial3: true), // 在 MaterialApp 裏面添加這行設定
  home: const Expenses(),
),
```

可設置種子顏色去生成一組相關聯的顏色，以便用於應用程式的主題設置：

```dart
// 通過 ColorScheme.fromSeed 方法傳入 seedColor 為種子顏色進行生成
var kColorS = ColorScheme.fromSeed(
  seedColor: Colors.lightGreenAccent.shade100,
);
```

可通過在 `MaterialApp` 小部件中設定 `theme` 來客製化主題樣式：

```dart
MaterialApp(
  theme: ThemeData().copyWith( // 使用 ThemeData().copyWith 以保留預設的 Material 主題並加以改寫
    useMaterial3: true,
    colorScheme: kColorS, // 指定應用程式主題中的各種顏色為我們用種子顏色生成的顏色
    primaryColor: kColorS.primary, // 設置主題的主要顏色為種子顏色中的主要顏色
    appBarTheme: const AppBarTheme().copyWith( // 設置 appBar 小部件的主題(通過 .copyWith 保留預設的樣式)
      foregroundColor: kColorS.onPrimary, // 更改前景色
      backgroundColor: kColorS.primary, // 更改背景色
    ),
    cardTheme: const CardTheme().copyWith( // 設置 Card 小部件的主題(通過 .copyWith 保留預設的樣式)
      elevation: 0.5, // 更改陰影程度
      color: kColorS.secondaryContainer, // 設置背景色
    ),
    filledButtonTheme: FilledButtonThemeData( // 設置 FilledButton 小部件的主題
      style: FilledButton.styleFrom( // 通過 FilledButton.styleFrom 保留預設的樣式
        elevation: 1, // 更改陰影程度
        shadowColor: kColorS.background, // 更改陰影顏色
        backgroundColor: kColorS.primary, // 更改 fill 的顏色
      ),
    ),
    textTheme: ThemeData().textTheme.copyWith( // 設置所有文字相關小部件的主題(通過 .copyWith 保留預設的樣式)
          titleLarge: TextStyle(
            fontSize: 20,
            color: kColorS.primary,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: kColorS.primary,
            height: 1,
          ),
          bodyMedium: TextStyle(
            color: kColorS.primary,
            height: 1,
          ),
          bodySmall: TextStyle(
            height: 1,
            color: kColorS.secondary,
          ),
        ),
  ),
  home: const Expenses(),
);
```

如果需要特別針對某個文字小部件選用文字主題可以這樣做：

```dart
Text(
  'Records',
  style: Theme.of(context).textTheme.titleLarge,
),
```

設置黑暗模式：

```dart
var kDarkColorS = ColorScheme.fromSeed( // 新增一個給黑暗模式用的種子顏色
  seedColor: const Color.fromARGB(255, 42, 96, 8),
  brightness: Brightness.dark, // 設定要生成深色主題用的顏色方案(默認是 Brightness.light)
);

MaterialApp(
  themeMode: ThemeMode.system, // 設置主題的模式為手機系統的模式(以哀鳳來說可在手機的設定中點擊開發者切換深色外觀)
  darkTheme: ThemeData.dark().copyWith( // 使用 ThemeData().dark().copyWith 以保留預設的 Material 的深色主題並加以改寫
    useMaterial3: true,
    colorScheme: kDarkColorS, // 指定應用程式主題中的各種顏色為我們用種子顏色生成的顏色
    primaryColor: kDarkColorS.primary, // 設置主題的主要顏色為種子顏色中的主要顏色
    scaffoldBackgroundColor: kDarkColorS.background, // 設置 Scaffold 小部件的背景色
    appBarTheme: const AppBarTheme().copyWith( // 設置 appBar 小部件的主題(通過 .copyWith 保留預設的樣式)
      foregroundColor: kDarkColorS.primary, // 更改前景色
      backgroundColor: kDarkColorS.onPrimary, // 更改背景色
    ),
    // ...後略
  ),
  home: const Expenses(),
)
```

在小部件中判斷當前的主題模式以顯示不同的顏色：

```dart
TextStyle(
  fontSize: 14,
  color: Theme.of(context).brightness == Brightness.dark
      ? kDarkColorS.onPrimaryContainer
      : const Color.fromARGB(255, 55, 55, 55),
);
```

## 顯示統計圖表的部分

在 `models/expense.dart` 檔案中添加設定 ExpenseBucket 的藍圖，用來獲取每個類別的數據：

```dart
class ExpenseBucket {
  ExpenseBucket(this.category, this.expenses);

  final Category category; // 傳入類別
  final List<Expense> expenses; // 傳入 Expense 的列表

  // 添加方法用來針對單個類別獲取數據
  ExpenseBucket.fromCategory(List<Expense> allExpense, this.category) 
      : expenses = allExpense
            .where((element) => element.category == category)
            .toList();

  // 添加獲取總金額的方法
  int get totalExpenses {
    int sum = 0;
    for (final e in expenses) {
      sum += e.price;
    }

    return sum;
  }
}
```

建立 `chart.dart` 檔案用來顯示統計圖表：

```dart
final List<Expense> expenses; // 傳入所有的 Expense 數據

List<ExpenseBucket> get allCategory { // 通過 get 方法獲取各個類別的 ExpenseBucket 數據並整合為 List
  return [
    ExpenseBucket.fromCategory(expenses, Category.food),
    ExpenseBucket.fromCategory(expenses, Category.learn),
    ExpenseBucket.fromCategory(expenses, Category.medical),
    ExpenseBucket.fromCategory(expenses, Category.shopping),
  ];
}

int total = 0; // 宣告一個變量用來存放總金額
for (var item in allCategory) { // 使用 for in 方法計算總金額
  total += item.totalExpenses; // 使用 ExpenseBucket 中的 totalExpenses 方法得到每個類別的總金額並進行加總
}

// 用 `Container` 小部件設置外觀
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Theme.of(context).brightness == Brightness.dark
        ? kDarkColorS.onPrimary
        : kColorS.secondaryContainer,
    border: Border.all(
      width: 1,
      color: Theme.of(context).brightness == Brightness.dark
          ? kDarkColorS.primary
          : kColorS.primary,
    ),
  ),
  padding: const EdgeInsets.symmetric(
    vertical: 8,
  ),
  child: Column( // 用 Column 小部件生成由上到下的排列
    children: [
      ...allCategory.map((e) => ChartBar(e, total, allCategory)), // 通過 map 方法產生各個分類的圖表小部件
    ],
  ),
);
```

新增自訂義的圖表小部件 `chart_bat.dart` ：

```dart
final ExpenseBucket item; // 各個分類的數據
final int total; // 總金額
final List<ExpenseBucket> allCategory; // 所有分類的 ExpenseBucket 列表

Row(
  children: [
    Column( // 用 Column 小部件顯示分類的 icon 與標題
      children: [
        Icon(
          cateIcon[item.category],
          size: 20,
          color: Theme.of(context).brightness == Brightness.dark
              ? kDarkColorS.primary
              : kColorS.onPrimaryContainer,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          cateZhName[item.category]!,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? kDarkColorS.primary
                : kColorS.onPrimaryContainer,
            fontSize: 12,
          ),
        )
      ],
    ),
    const SizedBox(
      width: 8,
    ),
    Expanded( // 用 Expanded 小部件確保圖表佔據最大可用寬度
      child: ClipRRect( // 用 ClipRRect 小部件設置圓角外觀
        borderRadius: BorderRadius.circular(4), 
        child: LinearProgressIndicator( // 用 LinearProgressIndicator 小部件生成百分比水平條狀圖
          value: (item.totalExpenses.toDouble() / total), // 設置填色區塊為 類別總金額➗總金額
          minHeight: 16, // 設置水平條狀圖的高度
          color: Theme.of(context).brightness == Brightness.dark // 設置填色區塊的顏色
              ? kDarkColorS.primary
              : kColorS.primary,
          backgroundColor: // 設置為填色區塊的背景色
              Theme.of(context).brightness == Brightness.dark
                  ? kDarkColorS.primaryContainer
                  : kColorS.primary.withOpacity(0.3),
        ),
      ),
    ),
  ],
);
```

最後可用 `Column` 小部件將整個 `Row` 小部件包起來，並在每個類別的 `Row` 下方新增分隔線小部件 `Divider`：

```dart
Column(
  children: [
    Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        children: [
          Column(
            // 顯示類別的 icon 與名稱
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            // 顯示水平條狀圖
          ),
        ],
      ),
    ),
    if (allCategory.last.category != item.category) // 判斷是否為最後一個分類，不是才顯示分隔線
      const Divider(), // 分隔線小部件
  ],
);
```