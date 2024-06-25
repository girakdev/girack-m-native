import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // このウィジェットはアプリケーションのルートです。
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter デモ',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'Flutter デモ ホームページ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // このウィジェットはアプリケーションのホームページです。ステートフルであるため、状態を保持する State オブジェクトが含まれています。
  // このオブジェクトには、見た目に影響を与えるフィールドが含まれています。

  // これは状態の設定クラスです。親（この場合は App ウィジェット）から提供される値（この場合はタイトル）を保持しており、
  // State のビルドメソッドで使用されます。ウィジェットサブクラスのフィールドは常に "final" としてマークされます。

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late final IO.Socket _socket;

  @override
  void initState() {
    super.initState();

    _socket = IO.io(
      "https://",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket.onConnect((_) {
      debugPrint('Girak Connect!');

      _socket.emit("auth", {
        {
          'username': "",
          'password': "",
        },
        "alpha_20240523"
      });
    });

    _socket.onConnectError((_) {
      debugPrint("ConnectError");
    });

    _socket.onError((_) {
      debugPrint("Error");
    });

    _socket.onDisconnect((_) {
      debugPrint("Girak Disconnect!");
    });

    _socket.on("authResult", (_) {
      debugPrint("Auth");
      debugPrint(_);
    });

    _socket.connect();
  }

  void _incrementCounter() {
    setState(() {
      // この setState の呼び出しにより、Flutter フレームワークに何かが変更されたことを伝え、
      // ビルドメソッドを再実行させて、表示を更新された値を反映するようにします。
      // もし setState を呼び出さずに _counter を変更した場合、ビルドメソッドが再実行されないため、
      // 何も表示されません。
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center はレイアウトウィジェットです。1 つの子ウィジェットを取り、その親の中央に配置します。
        child: Column(
          // Column もレイアウトウィジェットです。子ウィジェットのリストを縦方向に並べます。
          // デフォルトでは、子を水平に収めるように自分自身のサイズを調整し、親の高さに合わせて最大の高さになります。
          //
          // Column には、自分自身のサイズや子の配置方法を制御するさまざまなプロパティがあります。
          // ここでは mainAxisAlignment を使用して、子を垂直方向に中心に配置しています。
          // Column は縦方向のレイアウトのため、ここでのメイン軸は垂直軸です（クロス軸は水平軸になります）。
          //
          // 試してみてください: "デバッグペイントのトグル" アクション（IDE で "Toggle Debug Paint" アクションを選択するか、
          // コンソールで "p" を押します）を呼び出して、各ウィジェットの ワイヤーフレーム を表示します。
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '何回ボタンを押したか:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: '増やす',
        child: const Icon(Icons.add),
      ), // この末尾のカンマはビルドメソッドの自動整形をより良くします。
    );
  }
}
