#!/usr/bin/env python3

import jinja2
import argparse
import sys
import time


def create_parsers():
    main_parser = argparse.ArgumentParser(description="Main parser", add_help=False)
    subparsers = main_parser.add_subparsers(title="actions")
#    subparsers.required = True
    parser_repo = subparsers.add_parser("repo", parents=[main_parser],
                                        add_help=True,
                                        help="create .treeinfo for normal repository")
    parser_repo.set_defaults(command='repo')
    parser_baseos = subparsers.add_parser("baseos", parents=[main_parser],
                                          add_help=True,
                                          help="create .treeinfo for baseos")
    parser_baseos.set_defaults(command='baseos')
    # Common arguments
    for p in [parser_repo, parser_baseos]:
        p.add_argument("--arch", help="architecture", required=True)
        p.add_argument("--output-file", help="output file", required=True)
        p.add_argument("--family", help="variant (repo name)", required=True)
        p.add_argument("--version", help="version like 9.1, 8.7 or 33", required=True)
        p.add_argument("--variant", help="Variant/repo  name", required=True)
        p.add_argument("--family-short", help="Not required will use family when empty", default=None)
        p.add_argument("--packages-dir", help="name of packages dir."
                       "Default to Packages", default="Packages",
                       required=False)
        p.add_argument("--platforms", help="Not required. Defaults to the arch", default=None, required=False)
        p.add_argument("--timestamp", help="Not required. Defaults to the current epoch", type=int, default=None, required=False)
    parser_baseos.add_argument("--checksums", )
    return main_parser


def use_template_and_save(template_name, template_payload, save_to_path):
    fs_loader = jinja2.FileSystemLoader('templates')
    env = jinja2.Environment(loader=fs_loader)
    template = env.get_template(template_name)
    text_out = template.render(template_payload)
    with open(save_to_path, 'w') as f:
        f.write(text_out)


def create_repo_treeinfo(args):
    template_payload = {
        'arch': args.arch,
        'family': args.family,
        'family_short': args.family_short if args.family_short is not None else args.family,
        'packages_dir': args.packages_dir,
        'platforms': args.platforms if args.platforms is not None else args.arch,
        'variant': args.variant,
        'version': args.version,
        'timestamp': args.timestamp if args.timestamp is not None else int(time.time())  # epoch
    }
    use_template_and_save('repo.j2', template_payload, args.output_file)


def create_baseos_treeinfo(args):
    print("TODO")
    sys.exit(1)


if __name__ == '__main__':
    parser = create_parsers()
    # tried with subparser .required=True and .dest=commands but failed :(.
    if len(sys.argv) < 2 or '-h' in sys.argv or '--help' in sys.argv:
        parser.print_help()
    args = parser.parse_args()
    if args.command == 'repo':
        create_repo_treeinfo(args)
    elif args.command == 'baseos':
        create_repo_treeinfo(args)
