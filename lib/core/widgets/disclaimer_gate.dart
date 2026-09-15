import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/storage_service.dart';

class DisclaimerGate extends ConsumerStatefulWidget {
  final Widget child;
  const DisclaimerGate({super.key, required this.child});

  @override
  ConsumerState<DisclaimerGate> createState() => _DisclaimerGateState();
}

class _DisclaimerGateState extends ConsumerState<DisclaimerGate> {
  static const _agreedKey = 'disclaimer.agreed';
  bool _showDialog = false;

  @override
  void initState() {
    super.initState();
    _checkAgreement();
  }

  Future<void> _checkAgreement() async {
    final storage = ref.read(storageServiceProvider);
    final agreed = await storage.getBool(_agreedKey) ?? false;
    if (!agreed && mounted) {
      setState(() => _showDialog = true);
    }
  }

  Future<void> _agree() async {
    final storage = ref.read(storageServiceProvider);
    await storage.setBool(_agreedKey, true);
    if (mounted) setState(() => _showDialog = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showDialog)
          CupertinoAlertDialog(
            title: const Text('免责声明'),
            content: const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                '本应用为第三方修改版，仅供个人学习交流使用。\n\n'
                '1. 本应用与原作者无任何关联，不承担任何责任\n'
                '2. 使用本应用产生的任何问题（数据丢失、服务器异常等）由用户自行承担\n'
                '3. 请勿用于非法用途，遵守当地法律法规\n'
                '4. 如有侵权请联系删除\n\n'
                '点击"同意"即表示您已阅读并接受以上条款',
                textAlign: TextAlign.left,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: _agree,
                child: const Text('同意并继续'),
              ),
            ],
          ),
      ],
    );
  }
}
