import os
import osproc
import strformat

import ../configure
import ../assetsfile

import iface
import zippy/ziparchives

type
    ConsoleBase* = ref object of RootObj

iface *Console:
    proc getBinaryExtension(): string
    proc getConsoleName(): string
    proc getElfBinaryName(): string
    proc getIconExtension(): string
    proc publish(source: string)

proc getElfBinaryPath*(self: Console): string =
    ## Return the full path to the ELF binary

    return fmt("{config.binSearchPath}/{self.getElfBinaryName()}")

proc getOutputBinaryName*(self: Console): string =
    ## Return the filename with extension (.nro/3dsx)

    return fmt("{config.name}.{self.getBinaryExtension()}")

proc getOutputBinaryPath*(self: Console): string =
    ## Return the full path where the binary is output to

    return fmt("{config.build}/{self.getOutputBinaryName()}")

proc getTempBinaryPath*(self: Console): string =
    ## Return the temp build binary relative to the build directory

    return fmt("{config.build}/LOVEPotion.{self.getBinaryExtension()}")

proc getTempElfBinaryPath*(self: Console): string =
    ## Return the temp build ELF binary relative to the build directory

    return fmt("{config.build}/LOVEPotion_{self.getBinaryExtension()}")

proc getIcon*(self: Console): string =
    ## Return the full path to the icon
    ## If one isn't found, use the default icon

    var extension = self.getIconExtension()
    let filename = fmt("{config.icon}.{extension}")

    var iconData: string
    if not os.fileExists(filename):
        if extension == "nro":
            iconData = assetsfile.DefaultHacIcon
        else:
            iconData = assetsfile.DefaultCtrIcon

        writeFile(filename, iconData)

    return filename

proc packGameDirectory*(self: Console, romFS: string) =
    let content = fmt("{config.romFS}.love")
    let tempBinaryPath = self.getTempBinaryPath()

    try:
        ziparchives.createZipArchive(romFS, content)

        let binaryData = readFile(tempBinaryPath)
        writeFile(self.getOutputBinaryPath(), binaryData & readFile(content))

        os.removeFile(content)
    except Exception:
        return

proc getRomFSDirectory*(): string =
    ## Return the relative "RomFS" directory

    return fmt("{config.build}/{config.romFS}")

proc runCommand*(command: string) =
    ## Runs a specified command

    discard osproc.execCmdEx(command)
