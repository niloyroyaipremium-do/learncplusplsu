import 'package:flutter_test/flutter_test.dart';
import 'package:niloylearncplusplus/services/cpp_execution_service.dart';
import 'package:niloylearncplusplus/core/errors/app_exceptions.dart';

void main() {
  group('CppExecutionService', () {
    test('should execute simple C++ code successfully', () async {
      const code = '''
#include <iostream>
using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    return 0;
}
''';

      final result = await CppExecutionService.executeCode(code);

      expect(result.success, isTrue);
      expect(result.output, contains('Hello, World!'));
      expect(result.error, isEmpty);
    });

    test('should handle compilation errors', () async {
      const code = '''
#include <iostream>
using namespace std;

int main() {
    cout << "Hello, World!" << endl
    return 0;
}
''';

      final result = await CppExecutionService.executeCode(code);

      expect(result.success, isFalse);
      expect(result.error, isNotEmpty);
    });

    test('should handle runtime errors', () async {
      const code = '''
#include <iostream>
using namespace std;

int main() {
    int x = 10;
    int y = 0;
    int result = x / y;
    cout << result << endl;
    return 0;
}
''';

      final result = await CppExecutionService.executeCode(code);

      expect(result.success, isFalse);
      expect(result.error, isNotEmpty);
    });

    test('should respect timeout limits', () async {
      const code = '''
#include <iostream>
using namespace std;

int main() {
    while(true) {
        cout << "Infinite loop" << endl;
    }
    return 0;
}
''';

      final result = await CppExecutionService.executeCode(
        code,
        timeoutSeconds: 1,
      );

      expect(result.success, isFalse);
      expect(result.error, isNotEmpty);
    });

    test('should handle empty code', () async {
      const code = '';

      final result = await CppExecutionService.executeCode(code);

      expect(result.success, isFalse);
      expect(result.error, isNotEmpty);
    });

    test('should handle very long code', () async {
      final code = '''
#include <iostream>
using namespace std;

int main() {
    for(int i = 0; i < 1000; i++) {
        cout << "Line " << i << endl;
    }
    return 0;
}
''';

      final result = await CppExecutionService.executeCode(code);

      expect(result.success, isTrue);
      expect(result.output, isNotEmpty);
    });

    test('should use caching for repeated code', () async {
      const code = '''
#include <iostream>
using namespace std;

int main() {
    cout << "Cached result" << endl;
    return 0;
}
''';

      final result1 = await CppExecutionService.executeCode(
        code,
        useCache: true,
      );
      final result2 = await CppExecutionService.executeCode(
        code,
        useCache: true,
      );

      expect(result1.success, isTrue);
      expect(result2.success, isTrue);
      expect(result1.output, equals(result2.output));
    });

    test('should handle different optimization levels', () async {
      const code = '''
#include <iostream>
using namespace std;

int main() {
    int sum = 0;
    for(int i = 0; i < 1000000; i++) {
        sum += i;
    }
    cout << "Sum: " << sum << endl;
    return 0;
}
''';

      final resultO0 = await CppExecutionService.executeCode(
        code,
        optimizationLevel: '-O0',
      );
      final resultO2 = await CppExecutionService.executeCode(
        code,
        optimizationLevel: '-O2',
      );

      expect(resultO0.success, isTrue);
      expect(resultO2.success, isTrue);
    });

    test('should handle different C++ standards', () async {
      const code = '''
#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> numbers = {1, 2, 3, 4, 5};
    for(auto& num : numbers) {
        cout << num << " ";
    }
    cout << endl;
    return 0;
}
''';

      final result = await CppExecutionService.executeCode(
        code,
        cppStandard: 'c++11',
      );

      expect(result.success, isTrue);
      expect(result.output, contains('1 2 3 4 5'));
    });

    test('should handle code with input', () async {
      const code = '''
#include <iostream>
using namespace std;

int main() {
    int n;
    cin >> n;
    cout << "You entered: " << n << endl;
    return 0;
}
''';

      final result = await CppExecutionService.executeCode(code, input: '42');

      expect(result.success, isTrue);
      expect(result.output, contains('You entered: 42'));
    });
  });
}
