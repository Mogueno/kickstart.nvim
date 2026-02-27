# Environment Variables for Lambda Debugging

## Setup

### 1. Create `.env.lambda` file

In your Lambda function directory (e.g., `src/Functions/OracleSyncAcl.Functions.DomainEventsSynchronizer/`), create a file named `.env.lambda`:

```bash
# AWS Credentials
AWS_ACCESS_KEY_ID=ASIATFYF22E2ZKBZQ3IV
AWS_SECRET_ACCESS_KEY=D85jZOMPWRwk1bB96rQ9CrJ2cFeINvUy04LtdXBt
AWS_SESSION_TOKEN=IQoJb3JpZ2luX2VjEO...

# Oracle Settings
ORACLESETTINGS__PASSWORD=cR0jA919t#E458xxp
ORACLESETTINGS__USERNAME=Devvanessa

# Any other environment variables your Lambda needs
ASPNETCORE_ENVIRONMENT=Development
```

### 2. Add to `.gitignore`

**IMPORTANT**: Make sure `.env.lambda` is in your `.gitignore` to avoid committing secrets!

```bash
echo ".env.lambda" >> .gitignore
```

### 3. Use the Template

A template file `.env.lambda.template` was created for you. Copy it and fill in your actual values:

```bash
cd src/Functions/OracleSyncAcl.Functions.DomainEventsSynchronizer
cp .env.lambda.template .env.lambda
# Edit .env.lambda with your actual credentials
```

## How It Works

### Automatic Loading

When you debug with either method:
- **`<leader>dL`** - Quick start command
- **`<F5>` → "Lambda Test Tool - Launch"** - Debug menu

The configuration automatically:
1. Finds your Lambda function directory (via `aws-lambda-tools-defaults.json`)
2. Looks for `.env.lambda` in that directory
3. Loads all environment variables from the file
4. Passes them to the Lambda Test Tool

### File Format

The `.env.lambda` file uses simple `KEY=VALUE` format:

```bash
# Comments are supported (lines starting with #)
KEY_NAME=value here

# Quotes are optional but useful for values with spaces
DESCRIPTION="This is a long value"

# Special characters work fine
PASSWORD=p@ssw0rd!#$

# No quotes needed for most values
USERNAME=myusername
```

## Verification

After starting the Lambda Test Tool, check the notifications in Neovim:
- ✅ "Loaded X environment variables from .env.lambda" - Variables loaded successfully
- ⚠️  "No .env.lambda file found" - File doesn't exist (create it!)

## Debugging Env Vars

To verify your environment variables are loaded correctly:

1. Start the Lambda Test Tool
2. Open http://localhost:5050
3. In the browser dev tools (F12), check the Network tab
4. Your Lambda function will have access to these environment variables via `Environment.GetEnvironmentVariable("KEY_NAME")`

## Security Notes

1. **Never commit `.env.lambda`** - Add it to `.gitignore`
2. **Use AWS SSO** for temporary credentials when possible
3. **Rotate credentials regularly**
4. **Different environments** - You can create:
   - `.env.lambda.dev`
   - `.env.lambda.staging`
   - `.env.lambda.prod`
   And load the appropriate one

## Example Project Structure

```
OracleSyncAcl.Functions.DomainEventsSynchronizer/
├── .env.lambda                          ← Your actual secrets (gitignored)
├── .env.lambda.template                 ← Template without secrets (committed)
├── aws-lambda-tools-defaults.json       ← Auto-detection marker
├── Function.cs                          ← Your Lambda handler
└── OracleSyncAcl.Functions.*.csproj
```

## Troubleshooting

### Variables not loading?
- Check the file is named exactly `.env.lambda` (not `.env` or `env.lambda`)
- Verify it's in the same directory as `aws-lambda-tools-defaults.json`
- Check Neovim notifications for errors

### Wrong values?
- No spaces around the `=` sign
- Remove quotes if they're being included in the value
- Check for typos in variable names

### Still not working?
- Manually verify the file path:
  ```bash
  cat src/Functions/YourFunction/.env.lambda
  ```
- Check file permissions (should be readable)
