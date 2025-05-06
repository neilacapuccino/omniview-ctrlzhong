import 'package:flutter/material.dart';

class PremiumUI extends StatefulWidget {
  const PremiumUI({Key? key}) : super(key: key);

  @override
  State<PremiumUI> createState() => _PremiumUIState();
}

class _PremiumUIState extends State<PremiumUI> {
  bool isMonthly = true;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Widget> get _billboards => [
        _PremiumBillboard(
          title: 'Free Trial',
          description: 'Get free access to premium features. You will be billed after 30 days.',
          buttonText: 'Start Trial',
          onButtonPressed: () {},
          child: const SizedBox.shrink(),
          pricingRow: null,
        ),
        _PremiumBillboard(
          title: 'OmniView++',
          description: 'Get access to premium benefits and early access.',
          buttonText: '',
          onButtonPressed: () {},
          pricingRow: Row(
            children: [
              Text(
                isMonthly ? '₱120 / month' : '₱1200 / lifetime',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF402E68),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Purchase',
                  style: TextStyle(
                    color: Color(0xFF7E57C2),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isMonthly = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isMonthly ? const Color(0xFF7E57C2) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF7E57C2)),
                        ),
                        child: Center(
                          child: Text(
                            'Monthly',
                            style: TextStyle(
                              fontSize: 14,
                              color: isMonthly ? Colors.white : const Color(0xFF7E57C2),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isMonthly = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: !isMonthly ? const Color(0xFF7E57C2) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF7E57C2)),
                        ),
                        child: Center(
                          child: Text(
                            'Lifetime',
                            style: TextStyle(
                              fontSize: 14,
                              color: !isMonthly ? Colors.white : const Color(0xFF7E57C2),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _loopTo(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double boxSize = size.width * 0.7;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF402E68)),
        title: const Text('Premium', style: TextStyle(color: Color(0xFF402E68), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: boxSize,
                        height: boxSize,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _billboards.length,
                          onPageChanged: _onPageChanged,
                          itemBuilder: (context, index) {
                            return _billboards[index];
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF402E68)),
                            onPressed: () {
                              int prev = (_currentPage - 1 + _billboards.length) % _billboards.length;
                              _loopTo(prev);
                            },
                          ),
                          ...List.generate(_billboards.length, (i) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentPage == i ? const Color(0xFF7E57C2) : Colors.grey[300],
                                ),
                              )),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF402E68)),
                            onPressed: () {
                              int next = (_currentPage + 1) % _billboards.length;
                              _loopTo(next);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PremiumBillboard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final Widget child;
  final Widget? pricingRow;

  const _PremiumBillboard({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onButtonPressed,
    required this.child,
    this.pricingRow,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7E57C2).withOpacity(0.08),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF402E68),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF402E68)),
                  ),
                  if (title == 'Free Trial') ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7E57C2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        onPressed: onButtonPressed,
                        child: Text(
                          buttonText,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                  if (title == 'OmniView++' && pricingRow != null) ...[
                    const SizedBox(height: 32),
                    pricingRow!,
                    const SizedBox(height: 12),
                    child,
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
