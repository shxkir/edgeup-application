import 'package:edgeup_upsc_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:edgeup_upsc_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:edgeup_upsc_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_page_test.mocks.dart';

@GenerateMocks([AuthBloc])
void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<AuthBloc>(
      create: (_) => mockAuthBloc,
      child: const MaterialApp(
        home: LoginPage(),
      ),
    );
  }

  testWidgets('should display login form with email and password fields',
      (WidgetTester tester) async {
    // arrange
    when(mockAuthBloc.state).thenReturn(const AuthInitial());
    when(mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    // act
    await tester.pumpWidget(createWidgetUnderTest());

    // assert
    expect(find.text('Welcome to EdgeUp'), findsOneWidget);
    expect(find.text('UPSC Preparation Portal'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
  });

  testWidgets('should show validation error when email is empty',
      (WidgetTester tester) async {
    // arrange
    when(mockAuthBloc.state).thenReturn(const AuthInitial());
    when(mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    // act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.text('Login'));
    await tester.pump();

    // assert
    expect(find.text('Please enter your email'), findsOneWidget);
  });

  testWidgets('should show validation error when email is invalid',
      (WidgetTester tester) async {
    // arrange
    when(mockAuthBloc.state).thenReturn(const AuthInitial());
    when(mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    // act
    await tester.pumpWidget(createWidgetUnderTest());

    // Find email field and enter invalid email
    final emailField = find.byType(TextFormField).first;
    await tester.enterText(emailField, 'invalidemail');

    await tester.tap(find.text('Login'));
    await tester.pump();

    // assert
    expect(find.text('Please enter a valid email'), findsOneWidget);
  });

  testWidgets('should show validation error when password is empty',
      (WidgetTester tester) async {
    // arrange
    when(mockAuthBloc.state).thenReturn(const AuthInitial());
    when(mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    // act
    await tester.pumpWidget(createWidgetUnderTest());

    // Enter valid email
    final emailField = find.byType(TextFormField).first;
    await tester.enterText(emailField, 'test@example.com');

    await tester.tap(find.text('Login'));
    await tester.pump();

    // assert
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('should show validation error when password is too short',
      (WidgetTester tester) async {
    // arrange
    when(mockAuthBloc.state).thenReturn(const AuthInitial());
    when(mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    // act
    await tester.pumpWidget(createWidgetUnderTest());

    // Enter valid email and short password
    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, '123');

    await tester.tap(find.text('Login'));
    await tester.pump();

    // assert
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });

  testWidgets('should show loading indicator when auth is loading',
      (WidgetTester tester) async {
    // arrange
    when(mockAuthBloc.state).thenReturn(const AuthLoading());
    when(mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    // act
    await tester.pumpWidget(createWidgetUnderTest());

    // assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should toggle password visibility when icon is tapped',
      (WidgetTester tester) async {
    // arrange
    when(mockAuthBloc.state).thenReturn(const AuthInitial());
    when(mockAuthBloc.stream).thenAnswer((_) => const Stream.empty());

    // act
    await tester.pumpWidget(createWidgetUnderTest());

    // Find password field
    final passwordField = find.byType(TextFormField).last;
    final passwordWidget = tester.widget<TextFormField>(passwordField);

    // Initially password should be obscured
    expect(passwordWidget.obscureText, true);

    // Tap visibility icon
    final visibilityIcon = find.byIcon(Icons.visibility_outlined);
    await tester.tap(visibilityIcon);
    await tester.pump();

    // Password should now be visible
    final updatedPasswordWidget = tester.widget<TextFormField>(passwordField);
    expect(updatedPasswordWidget.obscureText, false);
  });
}
