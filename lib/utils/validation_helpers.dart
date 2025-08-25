/// Production-ready validation helpers for meelo mobile application
/// Provides secure, comprehensive input validation with proper RegEx patterns
/// and internationalization support.
class ValidationHelpers {
  // ====================
  // REGEX PATTERNS
  // ====================
  
  /// Email validation pattern following RFC 5322 standard (simplified but robust)
  /// Fixes: Original pattern was too simple and had escaping issues
  static final RegExp _emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    caseSensitive: false,
  );

  /// Person name pattern - supports international characters including diacritics
  /// Fixes: Original pattern was too restrictive for international names
  static final RegExp _namePattern = RegExp(
    r"^[a-zA-ZÀ-ÿĀ-žА-я\s\-\.\'\u00C0-\u017F]+$",
    caseSensitive: false,
  );

  /// Nickname pattern - allows alphanumeric + common safe symbols
  /// Fixes: Added more comprehensive character support
  static final RegExp _nicknamePattern = RegExp(
    r"^[a-zA-Z0-9À-ÿĀ-žА-я\s\-\.\'\u00C0-\u017F_]+$",
    caseSensitive: false,
  );

  /// International phone number pattern - supports various formats
  /// Fixes: Original pattern was too restrictive
  static final RegExp _phonePattern = RegExp(
    r'^\+?[1-9]\d{1,14}$|^\+?[\d\s\-\(\)\.]{7,20}$',
  );

  /// Password strength pattern - requires at least one letter and number
  /// Enhancement: Added minimum security requirements
  static final RegExp _strongPasswordPattern = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$',
  );

  /// Dangerous text pattern - detects harmful content
  /// Enhancement: More comprehensive security check  
  static final RegExp _dangerousTextPattern = RegExp(
    r'[<>{}]|script|javascript|on\w+\s*=',
    caseSensitive: false,
  );

  /// Harmful content patterns for security
  /// Enhancement: More comprehensive XSS and injection prevention
  static final List<RegExp> _harmfulPatterns = [
    RegExp(r'<\s*script[^>]*>[\s\S]*?<\s*/\s*script\s*>', caseSensitive: false),
    RegExp(r'javascript\s*:', caseSensitive: false),
    RegExp(r'on\w+\s*=', caseSensitive: false),
    RegExp(r'<\s*iframe[^>]*>', caseSensitive: false),
    RegExp(r'<\s*object[^>]*>', caseSensitive: false),
    RegExp(r'<\s*embed[^>]*>', caseSensitive: false),
    RegExp(r'<\s*link[^>]*>', caseSensitive: false),
    RegExp(r'<\s*meta[^>]*>', caseSensitive: false),
    RegExp(r'data\s*:', caseSensitive: false),
    RegExp(r'vbscript\s*:', caseSensitive: false),
    RegExp(r'expression\s*\(', caseSensitive: false),
    RegExp(r'@import', caseSensitive: false),
    RegExp(r'eval\s*\(', caseSensitive: false),
  ];

  // ====================
  // VALIDATION METHODS
  // ====================

  /// Validates email address format
  /// Returns true if email is valid according to RFC standards
  static bool isValidEmail(String email) {
    if (email.trim().isEmpty) return false;
    if (email.length > 254) return false; // RFC 5321 limit
    
    final trimmed = email.trim().toLowerCase();
    return _emailPattern.hasMatch(trimmed);
  }

  /// Validates person name format
  /// Supports international characters and common name formats
  static bool isValidName(String name) {
    if (name.trim().isEmpty) return false;
    if (name.trim().length < 1 || name.trim().length > 100) return false;
    
    final trimmed = name.trim();
    return _namePattern.hasMatch(trimmed) && !_hasConsecutiveSpaces(trimmed);
  }

  /// Validates nickname format
  /// More permissive than name validation
  static bool isValidNickname(String nickname) {
    if (nickname.trim().isEmpty) return true; // Optional field
    if (nickname.trim().length > 50) return false;
    
    final trimmed = nickname.trim();
    return _nicknamePattern.hasMatch(trimmed) && !_hasConsecutiveSpaces(trimmed);
  }

  /// Validates phone number format
  /// Supports international formats
  static bool isValidPhoneNumber(String phone) {
    if (phone.trim().isEmpty) return false;
    
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)\.]+'), '');
    return _phonePattern.hasMatch(cleaned) && cleaned.length >= 7 && cleaned.length <= 15;
  }

  /// Validates password strength
  /// Enhanced security requirements for production use
  static bool isStrongPassword(String password) {
    if (password.isEmpty) return false;
    if (password.length < 8 || password.length > 128) return false;
    
    // Check for common weak passwords
    final commonWeak = ['password', '12345678', 'qwerty123', 'abc12345'];
    if (commonWeak.contains(password.toLowerCase())) return false;
    
    return _strongPasswordPattern.hasMatch(password);
  }

  // ====================
  // VALIDATION WITH ERROR MESSAGES
  // ====================

  /// Validates text length with customizable parameters
  static String? validateLength(
    String? value, {
    required int minLength,
    required int maxLength,
    required String fieldName,
    bool required = true,
  }) {
    if (value == null || value.trim().isEmpty) {
      return required ? '$fieldName is required' : null;
    }

    final trimmed = value.trim();
    if (trimmed.length < minLength) {
      return '$fieldName must be at least $minLength character${minLength == 1 ? '' : 's'} long';
    }

    if (trimmed.length > maxLength) {
      return '$fieldName must be no more than $maxLength character${maxLength == 1 ? '' : 's'} long';
    }

    return null;
  }

  /// Validates email with comprehensive error messages
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email address is required';
    }

    final trimmed = email.trim();
    
    if (trimmed.length > 254) {
      return 'Email address is too long';
    }

    if (!isValidEmail(trimmed)) {
      if (!trimmed.contains('@')) {
        return 'Email address must contain @ symbol';
      }
      if (trimmed.startsWith('@') || trimmed.endsWith('@')) {
        return 'Email address format is invalid';
      }
      if (!trimmed.contains('.') || trimmed.split('@').last.split('.').last.length < 2) {
        return 'Email address must have a valid domain';
      }
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates name with enhanced error messages
  static String? validateName(String? name, {bool required = true, String fieldName = 'Name'}) {
    if (name == null || name.trim().isEmpty) {
      return required ? '$fieldName is required' : null;
    }

    final lengthError = validateLength(
      name,
      minLength: 1,
      maxLength: 100,
      fieldName: fieldName,
      required: required,
    );
    if (lengthError != null) return lengthError;

    final trimmed = name.trim();
    
    if (_hasConsecutiveSpaces(trimmed)) {
      return '$fieldName cannot have consecutive spaces';
    }

    if (!_namePattern.hasMatch(trimmed)) {
      return '$fieldName can only contain letters, spaces, hyphens, periods, and apostrophes';
    }

    // Check for suspicious patterns
    if (containsHarmfulContent(trimmed)) {
      return '$fieldName contains invalid characters';
    }

    return null;
  }

  /// Validates nickname with specific rules
  static String? validateNickname(String? nickname) {
    if (nickname == null || nickname.trim().isEmpty) {
      return null; // Nickname is optional
    }

    final lengthError = validateLength(
      nickname,
      minLength: 0,
      maxLength: 50,
      fieldName: 'Nickname',
      required: false,
    );
    if (lengthError != null) return lengthError;

    if (!isValidNickname(nickname)) {
      return 'Nickname can only contain letters, numbers, spaces, hyphens, periods, underscores, and apostrophes';
    }

    if (containsHarmfulContent(nickname)) {
      return 'Nickname contains invalid characters';
    }

    return null;
  }

  /// Validates figure name (simplified validation)
  static String? validateFigureName(String? name) {
    return validateName(name, required: true, fieldName: 'Figure name');
  }

  /// Validates description with length limits
  static String? validateDescription(String? description) {
    if (description == null || description.trim().isEmpty) {
      return null; // Description is optional
    }

    final lengthError = validateLength(
      description,
      minLength: 0,
      maxLength: 1000,
      fieldName: 'Description',
      required: false,
    );
    if (lengthError != null) return lengthError;

    if (containsHarmfulContent(description)) {
      return 'Description contains invalid content';
    }

    return null;
  }

  /// Validates contact information
  static String? validateContactInfo(String? contactInfo) {
    if (contactInfo == null || contactInfo.trim().isEmpty) {
      return null; // Contact info is optional
    }

    final lengthError = validateLength(
      contactInfo,
      minLength: 0,
      maxLength: 300,
      fieldName: 'Contact information',
      required: false,
    );
    if (lengthError != null) return lengthError;

    if (containsHarmfulContent(contactInfo)) {
      return 'Contact information contains invalid content';
    }

    return null;
  }

  /// Validates password with enhanced security requirements
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (password.length > 128) {
      return 'Password must be no more than 128 characters long';
    }

    if (!RegExp(r'[A-Za-z]').hasMatch(password)) {
      return 'Password must contain at least one letter';
    }

    if (!RegExp(r'\d').hasMatch(password)) {
      return 'Password must contain at least one number';
    }

    if (!RegExp(r'[@$!%*#?&]').hasMatch(password)) {
      return 'Password must contain at least one special character (@\$!%*#?&)';
    }

    // Check for common weak passwords
    final commonWeak = ['password123', '12345678', 'qwerty123', 'abc12345'];
    if (commonWeak.contains(password.toLowerCase())) {
      return 'Password is too common, please choose a stronger password';
    }

    return null;
  }

  /// Validates password confirmation
  static String? validatePasswordConfirmation(String? password, String? confirmation) {
    if (confirmation == null || confirmation.isEmpty) {
      return 'Password confirmation is required';
    }

    if (password != confirmation) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validates phone number with detailed error messages
  static String? validatePhoneNumber(String? phone, {bool required = false}) {
    if (phone == null || phone.trim().isEmpty) {
      return required ? 'Phone number is required' : null;
    }

    if (!isValidPhoneNumber(phone)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // ====================
  // SANITIZATION METHODS
  // ====================

  /// Sanitizes text input by removing excessive whitespace and harmful content
  static String sanitizeText(String? input) {
    if (input == null) return '';

    return input
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ') // Replace multiple spaces with single space
        .replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), ''); // Remove control characters
  }

  /// Sanitizes email input
  static String sanitizeEmail(String? email) {
    if (email == null) return '';

    return email.trim().toLowerCase().replaceAll(RegExp(r'\s'), '');
  }

  /// Sanitizes phone number input
  static String sanitizePhoneNumber(String? phone) {
    if (phone == null) return '';

    return phone.trim().replaceAll(RegExp(r'[^\d\+\-\(\)\s\.]'), '');
  }

  // ====================
  // SECURITY METHODS
  // ====================

  /// Checks for potentially harmful content including XSS and injection attempts
  static bool containsHarmfulContent(String? text) {
    if (text == null || text.trim().isEmpty) return false;

    final lowercaseText = text.toLowerCase();
    
    // Check against harmful patterns
    for (final pattern in _harmfulPatterns) {
      if (pattern.hasMatch(lowercaseText)) {
        return true;
      }
    }

    // Check for SQL injection patterns
    final sqlPatterns = ['union select', 'drop table', 'insert into', 'delete from', '--', ';--'];
    for (final pattern in sqlPatterns) {
      if (lowercaseText.contains(pattern)) {
        return true;
      }
    }

    return false;
  }

  /// Comprehensive validation and sanitization
  static String? validateAndSanitize(
    String? input, {
    required int minLength,
    required int maxLength,
    required String fieldName,
    bool allowSpecialChars = false,
    bool required = true,
  }) {
    if (input == null || input.trim().isEmpty) {
      return required ? '$fieldName is required' : null;
    }

    // Check for harmful content before processing
    if (containsHarmfulContent(input)) {
      return '$fieldName contains invalid or potentially harmful content';
    }

    // Sanitize the input
    final sanitized = sanitizeText(input);

    // Check length after sanitization
    if (sanitized.length < minLength && required) {
      return '$fieldName must be at least $minLength character${minLength == 1 ? '' : 's'} long';
    }

    if (sanitized.length > maxLength) {
      return '$fieldName must be no more than $maxLength character${maxLength == 1 ? '' : 's'} long';
    }

    // Check for dangerous characters if special chars are not allowed
    if (!allowSpecialChars && _dangerousTextPattern.hasMatch(sanitized)) {
      return '$fieldName contains invalid characters';
    }

    return null;
  }

  // ====================
  // HELPER METHODS
  // ====================

  /// Checks if text has consecutive spaces
  static bool _hasConsecutiveSpaces(String text) {
    return text.contains(RegExp(r'\s{2,}'));
  }

  /// Estimates password strength (0-4 scale)
  static int getPasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;

    // Length check
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;

    // Character variety checks
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'\d').hasMatch(password)) strength++;
    if (RegExp(r'[@$!%*#?&]').hasMatch(password)) strength++;

    // Penalty for common patterns
    if (RegExp(r'(.)\1{2,}').hasMatch(password)) strength--; // Repeated characters
    if (RegExp(r'123|abc|qwe', caseSensitive: false).hasMatch(password)) strength--; // Sequential

    return strength.clamp(0, 4);
  }

  /// Gets password strength description
  static String getPasswordStrengthDescription(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Very Weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Unknown';
    }
  }
}