# Contributing to BravePurifier

Thank you for your interest in contributing to BravePurifier! This guide will help you get started with contributing to the project.

## 🤝 Ways to Contribute

### 🐛 Bug Reports
- Report installation issues
- Document configuration problems
- Identify compatibility issues
- Report security vulnerabilities

### 💡 Feature Requests
- Suggest new privacy enhancements
- Propose additional Linux distribution support
- Request new configuration options
- Suggest documentation improvements

### 💻 Code Contributions
- Fix bugs and issues
- Add new features
- Improve existing functionality
- Optimize performance

### 📚 Documentation
- Improve README and wiki pages
- Add usage examples
- Create tutorials and guides
- Translate documentation

### 🧪 Testing
- Test on different Linux distributions
- Verify privacy features
- Test edge cases and scenarios
- Performance testing

## 🚀 Getting Started

### Prerequisites
- Linux system (any supported distribution)
- Git installed
- Basic knowledge of Bash scripting
- Understanding of Linux package managers

### Development Setup

1. **Fork the Repository**
   ```bash
   # Fork on GitHub, then clone your fork
   git clone https://github.com/YOUR_USERNAME/BravePurifier.git
   cd BravePurifier
   ```

2. **Create Development Branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b bugfix/issue-description
   ```

3. **Set Up Development Environment**
   ```bash
   # Make script executable
   chmod +x brave-purifier.sh
   
   # Test current functionality
   sudo ./brave-purifier.sh --help
   ```

## 📝 Development Guidelines

### Code Style

#### Bash Scripting Standards
```bash
# Use strict error handling
set -euo pipefail

# Use readonly for constants
readonly SCRIPT_VERSION="1.0"

# Use local variables in functions
function example_function() {
    local variable_name="value"
}

# Use descriptive function names
check_root() { ... }
detect_package_manager() { ... }
```

#### Naming Conventions
- **Functions**: `snake_case` (e.g., `install_brave`, `apply_policies`)
- **Variables**: `UPPER_CASE` for constants, `snake_case` for locals
- **Files**: `kebab-case` (e.g., `brave-purifier.sh`)

#### Error Handling
```bash
# Always check command success
if ! command -v apt >/dev/null 2>&1; then
    error "APT not found"
    exit 1
fi

# Use proper error messages
error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1" >&2; }
```

### Documentation Standards

#### Code Comments
```bash
# Function description
# Arguments: $1 - package manager name
# Returns: 0 on success, 1 on failure
detect_package_manager() {
    # Implementation details
}
```

#### Commit Messages
```
type(scope): description

feat(install): add support for Alpine Linux
fix(policies): correct JSON syntax in privacy policy
docs(wiki): update installation guide
test(arch): add Arch Linux testing
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### Testing Requirements

#### Manual Testing
```bash
# Test on clean system
sudo ./brave-purifier.sh

# Test updates
sudo ./brave-purifier.sh  # Run twice

# Test error conditions
./brave-purifier.sh  # Without sudo (should fail)
```

#### Distribution Testing
Test on multiple distributions:
- Ubuntu 22.04 LTS
- Fedora 39
- Arch Linux (latest)
- openSUSE Leap 15.5
- Debian 12

#### Privacy Verification
```bash
# Verify policies are applied
cat /etc/brave/policies/managed/privacy-policy.json

# Test privacy features
brave-browser chrome://policy/
```

## 🔧 Development Workflow

### 1. Issue Creation
Before starting work:
- Check existing issues
- Create detailed issue description
- Discuss approach with maintainers
- Get approval for major changes

### 2. Development Process
```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes
# ... edit files ...

# Test thoroughly
sudo ./brave-purifier.sh

# Commit changes
git add .
git commit -m "feat(feature): add new feature"

# Push to your fork
git push origin feature/new-feature
```

### 3. Pull Request Process
1. **Create Pull Request** on GitHub
2. **Fill out PR template** completely
3. **Link related issues** using keywords
4. **Request review** from maintainers
5. **Address feedback** promptly
6. **Ensure CI passes** (when implemented)

### Pull Request Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement

## Testing
- [ ] Tested on Ubuntu
- [ ] Tested on Fedora
- [ ] Tested on Arch Linux
- [ ] Privacy features verified

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes
```

## 🧪 Testing Guidelines

### Test Categories

#### 1. Installation Testing
```bash
# Fresh installation
sudo ./brave-purifier.sh

# Update existing installation
sudo ./brave-purifier.sh

# Error conditions
./brave-purifier.sh  # No sudo
FORCE_PM="invalid" sudo ./brave-purifier.sh  # Invalid PM
```

#### 2. Privacy Testing
```bash
# Verify policies
ls -la /etc/brave/policies/managed/
cat /etc/brave/policies/managed/privacy-policy.json | jq .

# Test user settings
cat ~/.config/BraveSoftware/Brave-Browser/Default/Preferences | jq .

# Browser testing
brave-browser chrome://policy/
brave-browser chrome://settings/privacy
```

#### 3. Distribution Testing
Test matrix:
- **Ubuntu**: 20.04, 22.04, 23.04
- **Fedora**: 37, 38, 39
- **Arch**: Latest rolling
- **Debian**: 11, 12
- **openSUSE**: Leap 15.5, Tumbleweed

#### 4. Edge Case Testing
```bash
# Network issues
# Simulate network failure during download

# Permission issues
# Test with different user permissions

# Existing installations
# Test with various existing Brave versions

# Corrupted files
# Test recovery from corrupted configurations
```

### Test Automation

#### Basic Test Script
```bash
#!/bin/bash
# test-basic.sh

set -euo pipefail

# Test help output
./brave-purifier.sh --help

# Test version output
./brave-purifier.sh --version

# Test without sudo (should fail)
if ./brave-purifier.sh 2>/dev/null; then
    echo "ERROR: Script should require sudo"
    exit 1
fi

echo "Basic tests passed"
```

## 📋 Issue Guidelines

### Bug Reports
Include:
- **System Information**: OS, version, architecture
- **Error Messages**: Complete error output
- **Steps to Reproduce**: Detailed reproduction steps
- **Expected Behavior**: What should happen
- **Actual Behavior**: What actually happens
- **Log Files**: Relevant log excerpts

### Feature Requests
Include:
- **Problem Description**: What problem does this solve?
- **Proposed Solution**: How should it work?
- **Alternatives Considered**: Other approaches considered
- **Additional Context**: Screenshots, examples, etc.

### Security Issues
For security vulnerabilities:
- **Do NOT** create public issues
- **Email**: security@nightcodex7.dev
- **Include**: Detailed vulnerability description
- **Provide**: Steps to reproduce
- **Suggest**: Potential fixes if known

## 🏷️ Release Process

### Version Numbering
BravePurifier uses semantic versioning:
- **Major** (X.0.0): Breaking changes
- **Minor** (1.X.0): New features, backward compatible
- **Patch** (1.0.X): Bug fixes, backward compatible

### Release Checklist
- [ ] All tests pass
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version number bumped
- [ ] Git tag created
- [ ] Release notes written

## 🎯 Priority Areas

### High Priority
- **Security**: Privacy and security enhancements
- **Compatibility**: Support for new Linux distributions
- **Bug Fixes**: Critical installation and configuration issues
- **Documentation**: Clear, comprehensive guides

### Medium Priority
- **Features**: New privacy features and options
- **Performance**: Script optimization and speed improvements
- **Testing**: Automated testing and CI/CD
- **Usability**: Better error messages and user experience

### Low Priority
- **Refactoring**: Code cleanup and organization
- **Optimization**: Minor performance improvements
- **Cosmetic**: UI/UX improvements

## 📞 Communication

### Channels
- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and ideas
- **Pull Requests**: Code review and collaboration
- **Email**: security@nightcodex7.dev (security issues only)

### Response Times
- **Security Issues**: Within 24 hours
- **Bug Reports**: Within 48 hours
- **Feature Requests**: Within 1 week
- **Pull Requests**: Within 1 week

### Code of Conduct
- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow
- Follow GitHub's community guidelines

## 🏆 Recognition

### Contributors
All contributors are recognized in:
- **README.md**: Contributors section
- **CHANGELOG.md**: Release notes
- **GitHub**: Contributor graphs and statistics

### Types of Recognition
- **Code Contributors**: Listed in README
- **Bug Reporters**: Mentioned in changelog
- **Documentation**: Credited in wiki pages
- **Testers**: Acknowledged in release notes

## 📚 Resources

### Learning Resources
- **Bash Scripting**: [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)
- **Linux Packaging**: Distribution-specific documentation
- **Privacy Technologies**: [Privacy Guides](https://privacyguides.org/)
- **Git Workflow**: [GitHub Flow](https://guides.github.com/introduction/flow/)

### Tools
- **Shellcheck**: Bash script linting
- **jq**: JSON processing
- **Git**: Version control
- **GitHub CLI**: Command-line GitHub interface

---

**Thank you for contributing to BravePurifier! Your efforts help make the internet more private and secure for everyone.**

*For questions about contributing, create a discussion thread or contact the maintainers.*