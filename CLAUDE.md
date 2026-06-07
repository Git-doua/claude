# PL/SQL Project - Oracle Database 19c

## Database Environment
- **Target Database:** Oracle Database 19c
- **Language:** PL/SQL
- **Official Resources:** [Oracle Skills Repository](https://github.com/oracle/skills)

## Project Structure
```
/procedures  - Stored procedures
/functions   - User-defined functions
/packages    - Package specifications and bodies
/triggers    - Database triggers
/views       - Database views
/ddl         - Data Definition Language (CREATE TABLE, ALTER, etc.)
/scripts     - Utility and deployment scripts
```

## PL/SQL Standards & Best Practices

### Coding Conventions
- Use Oracle 19c compatible syntax only (avoid features from 21c, 23ai, etc.)
- Follow Oracle naming conventions:
  - Procedures/Functions: `verb_noun` (e.g., `get_employee`, `create_order`)
  - Packages: `noun_pkg` (e.g., `employee_pkg`, `order_pkg`)
  - Tables: `plural_nouns` (e.g., `employees`, `orders`)
  - Triggers: `table_event_trg` (e.g., `employees_bi_trg`)

### Error Handling
- Always use exception handling blocks
- Use named exceptions where appropriate
- Log errors with meaningful messages
- Use `RAISE_APPLICATION_ERROR` for custom errors (-20000 to -20999)

### Performance Guidelines
- Use bind variables to prevent SQL injection and improve performance
- Avoid implicit cursors for large datasets
- Use BULK COLLECT and FORALL for batch operations
- Add appropriate indexes for frequently queried columns

### Security
- Validate all input parameters
- Use bind variables to prevent SQL injection
- Follow principle of least privilege for database grants
- Avoid dynamic SQL where possible; if required, validate inputs rigorously

### Documentation
- Add header comments to all procedures, functions, and packages:
  ```sql
  /*
  ** Purpose: [Brief description]
  ** Author: [Name]
  ** Date: [Creation date]
  ** Parameters:
  **   p_param1 - [Description]
  ** Returns: [For functions]
  */
  ```

## Oracle 19c Specific Features to Leverage
- Private temporary tables (if needed)
- Polymorphic table functions
- SQL Macros
- Automatic indexing (if enabled)

## References
- [Oracle 19c Documentation](https://docs.oracle.com/en/database/oracle/oracle-database/19/)
- [Oracle Skills - Database Domain](https://github.com/oracle/skills/tree/main/db)
- [PL/SQL Best Practices](https://github.com/oracle/skills/blob/main/db/application-development/plsql/)

## Development Workflow
1. Create/modify PL/SQL objects in appropriate directories
2. Test in development environment
3. Code review before commit
4. Commit with descriptive messages
5. Push to GitHub repository

## Notes
- When providing assistance with PL/SQL code:
  - Ensure Oracle 19c compatibility
  - Follow the standards documented here
  - Reference Oracle official documentation when applicable
  - Optimize for performance and security
