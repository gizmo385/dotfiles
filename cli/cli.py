import click


@click.command()
@click.option('-v', '--verbose', count=True)
def cli(verbose: int) -> None:
    click.echo(f'Verbosity = {verbose}')


if __name__ == '__main__':
    cli()
