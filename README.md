# heroku-cleanup

Clean up your Heroku account

## Installation

    $ heroku plugins:install https://github.com/ddollar/heroku-cleanup.git

## Usage

* `y`: Remove yourself from apps you don't own or delete apps you do own.
* `n`: Leave this app alone
* `k`: Keep this app and stop asking about it

<!-- -->

    $ heroku cleanup
    [1/102] Remove yourself from example1? [y/N/k] y
    [2/102] Remove yourself from example2? [y/N/k] y
    [3/102] Delete example3? [y/N/k] n

## License

MIT
