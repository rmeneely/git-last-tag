# git-last-tag
This GitHub Action determines returns the most recent matching tag, setting the ${{ env.LAST_TAG }} environment variable.

## Usage
```yaml
    - uses: rmeneely/git-last-tag@v1
      with:
        # Tag pattern. The filter to use when searching for the LAST_VERSION tag
        # Optional
        # Default: 'v[0-9]*.[0-9]*.[0-9]*'
        tag_pattern: 'v[0-9]*.[0-9]*.[0-9]*'

```

## Examples
```yaml
    # Sets LAST_TAG environment variable to last matching tag
    # Example: 
    - uses: rmeneely/git-last-tag@v1
```

```yaml
    # Sets LAST_TAG environment variable to last matching tag
    # Example: 
    - uses: rmeneely/git-last-tag@v1
      with:
        tag_pattern: 'rc[0-9]*'
```


## Output
```shell
# If run as GitHub Action - sets the following $GITHUB_ENV variable
# If run as script - prints the following variables
LAST_TAG=<last tag>
```

## License
The MIT License (MIT)
