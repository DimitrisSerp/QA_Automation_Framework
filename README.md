# Novibet Automation Test Project

## 📘 Overview

This project was developed as part of the recruitment process for the Senior Automation Test Engineer position at Novibet.

The solution is implemented using **Robot Framework** and checks:
- If matches appear **on time**
- If they are **delayed**
- If they are **dropped** (not live after 20 minutes)

## ⚙️ Requirements

- Python 3.11
- Robot Framework 4.1.3
- SeleniumLibrary 3.141.0
- Browser WebDriver (ChromeDriver)

(You need to install requirements before running the project)

## 🚀 How to Run

1. Extract the contents or clone the repository if it is uploaded on git.
2. Make sure `ChromeDriver` or your preferred browser driver is in your PATH.
3. Run the test suite:

```bash
robot -A [path_to_arg_file] --listener [path_to_test_runner_agent] [path_to_Novibet's_parent_folder]
```

## 🧪 Test Structure

- `Tests/NOV-0000.robot`: Main test suite executing all 5 required tasks
- `Resources/PortalPages`: Page Object files for Live Schedule and Live Betting pages
- `Resources/Reports/XML.resource`: Handles generation of the XML report
- `Locators.json`: Configurable file with locators used across the framework
- `Setup.resource`: Contains environment setup and teardown

## 🧩 Features Implemented for Extra Points

- Page Object Model for maintainability
- Config file for flexible locator changes
- XML report generation with timestamps (GMT+2)
- Robust setup/teardown logic
- Modular and extendable structure

## 👤 Candidate Note

This framework was built with stability, clarity, and maintainability in mind.  
It simulates a real-world QA automation task and demonstrates readiness for production-grade test automation.
