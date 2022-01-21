#!/usr/bin/env python3
import pefile, argparse


def EATDump(pe_path: str):
    PE = pefile.PE(pe_path)
    EARArr = []
    for EAR in PE.DIRECTORY_ENTRY_EXPORT.symbols:
        EARArr.append({
            "ordinal": EAR.ordinal,
            "function": EAR.name.decode('utf-8') if EAR.name is not None else "",
            "address": hex(PE.OPTIONAL_HEADER.ImageBase + EAR.address)
        })
    return EARArr


def EATFormat(EARArr: list, new_dll_name: str, dump_path: str):
    with open(dump_path, 'w') as f:
        for EAR in EARArr:
            if EAR['function'] != "":
                s = f"#pragma comment(linker, \"/export:{EAR['function']}={new_dll_name}.{EAR['function']},@{EAR['ordinal']}\")"
                print(s)
                f.write(s + "\n")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('pe_path', metavar='PE_PATH', type=str, nargs='?', help='PE File Path')
    parser.add_argument('old_dll_name', metavar='OLD_DLL_NAME', type=str, nargs='?', help='Old DLL Name')
    parser.add_argument('new_dll_name', metavar='NEW_DLL_NAME', type=str, nargs='?', help='New DLL Name')
    parser.add_argument('dump_path', metavar='DUMP_PATH', type=str, nargs='?', help='Dump TXT Path')
    args = parser.parse_args()
    EATFormat(EATDump(args.pe_path), args.new_dll_name, args.dump_path)


if __name__ == '__main__':
    main()
