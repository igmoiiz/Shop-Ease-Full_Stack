// ignore_for_file: deprecated_member_use

import 'package:auth_screens/Controllers/Authentication/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auth_screens/Controllers/input_controllers.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>
    with SingleTickerProviderStateMixin {
  // Animation controller
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Form key and controllers
  final _formKey = GlobalKey<FormState>();
  final InputControllers _inputControllers = InputControllers();
  final AuthServices _authServices = AuthServices();

  // Loading state
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuint));

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Method to handle password reset
  void _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the password reset method from auth_services
      await _authServices.restorePassword(
        _inputControllers.emailController.text,
        context,
      );

      // Set success state after API call
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    } catch (e) {
      // Handle error
      setState(() {
        _isLoading = false;
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to send reset link. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            height: size.height - MediaQuery.of(context).padding.top,
            width: size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.yellow.shade800,
                    ),
                  ),
                ),

                // Animated content
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),

                            // Header
                            Text(
                              "Forgot Password",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontFamily: GoogleFonts.outfit().fontFamily,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Subtitle
                            Text(
                              _emailSent
                                  ? "We've sent a password reset link to your email. Please check your inbox."
                                  : "Enter your email address and we'll send you a link to reset your password.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: size.height * 0.06),

                            // Form
                            if (!_emailSent) ...[
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Email label
                                    Text(
                                      "Email Address",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        fontFamily:
                                            GoogleFonts.outfit().fontFamily,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Email field
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.03,
                                            ),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        controller:
                                            _inputControllers.emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: 15,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Enter your email",
                                          hintStyle: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 14,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.email_outlined,
                                            color: Colors.yellow.shade800,
                                            size: 20,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 16,
                                              ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          if (!RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                          ).hasMatch(value)) {
                                            return 'Please enter a valid email';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),

                                    SizedBox(height: size.height * 0.05),

                                    // Submit button
                                    SizedBox(
                                      width: double.infinity,
                                      height: 55,
                                      child: ElevatedButton(
                                        onPressed:
                                            _isLoading ? null : _resetPassword,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.yellow.shade800,
                                          foregroundColor: Colors.white,
                                          disabledBackgroundColor: Colors
                                              .yellow
                                              .shade800
                                              .withOpacity(0.7),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          elevation: 5,
                                          shadowColor: Colors.yellow.shade800
                                              .withOpacity(0.5),
                                        ),
                                        child:
                                            _isLoading
                                                ? SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                                : Text(
                                                  "Send Reset Link",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                  ),
                                                ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              // Success animation
                              Center(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check_circle,
                                        size: 80,
                                        color: Colors.green.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      "Email Sent!",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade700,
                                        fontFamily:
                                            GoogleFonts.outfit().fontFamily,
                                      ),
                                    ),
                                    const SizedBox(height: 50),

                                    // Back to login button
                                    SizedBox(
                                      width: double.infinity,
                                      height: 55,
                                      child: ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.green.shade600,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          elevation: 5,
                                          shadowColor: Colors.green.shade600
                                              .withOpacity(0.5),
                                        ),
                                        child: Text(
                                          "Back to Login",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily:
                                                GoogleFonts.poppins()
                                                    .fontFamily,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom section with decorative element
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        height: 100,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive an email? ",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  _isLoading
                                      ? null
                                      : () {
                                        if (_emailSent) {
                                          // Resend the reset link
                                          _resetPassword();
                                        } else {
                                          // Focus on form
                                          FocusScope.of(
                                            context,
                                          ).requestFocus(FocusNode());
                                        }
                                      },
                              child: Text(
                                "Resend",
                                style: TextStyle(
                                  color: Colors.yellow.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
