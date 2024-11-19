# Fleeing File

This is a fun and silly Bash script that randomly moves around the directory structure and tries to hide itself in a random subdirectory.

## Usage

1. Make the script executable:

   ```sh
   chmod +x catch-me.sh
   ```

2. Add this to your `.bashrc`:

   ```sh
   function cd_and_catch() {
       cd "$@"
       ./catch-me.sh 2>/dev/null
   }
   alias cd='cd_and_catch'
   ```

3. Run the script for the first time:
   ```sh
   ./catch-me.sh
   ```

Enjoy the chase!

## Debug Mode

To enable debug mode, set the `DEBUG` variable to `1` at the top of the script:

```sh
DEBUG=1
```

In debug mode, the script will print additional information about its actions and will not actually move itself.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
