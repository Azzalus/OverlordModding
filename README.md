# Welcome to the Overlord Modding Repository

![Overlord Modding Logo](OLM_Logo.png)


# Basic File Formats
 - incomplete list
 - [SPF](#SPF)
 - [PSP](#PSP)
 - [OSI](#OSI)
 - [OSG](#OSG)
 - [TZF](#TZF)
 - [MAP](#MAP)
 - [DTA](#DTA)
 - [PRP](#PRP)
 - [RPK](#RPK)
 - [CLB](#CLB)
 - [OMP](#OMP)
 - [8LD](#8LD)
 - [MP3](#MP3)
 - [DDS](#DDS)
 - [DAT](#DAT)


# How to modify each file type

## DAT

Open in a hex editor of your choice, do NOT use regular notepad as these files use NULL characters rather than space characters, and some have sizes written in bytes.

## DDS

Open the file in Paint.net or alternatively if you want to use GIMP there is a DDS plugin you can use. All images are DXT1, though the engine might be able to load higher quality images like DXT3, I simply havent tested it.

## MP3

Audacity can export mp3's as long as you have the LAME encoder for it, and many other audio software suites allow exporting in MP3 format. FFMPEG can also convert audio files to/from MP3 when needed. Virtually every audio player in existence can play back these files.

## 8LD

Language file of some sort
Under Construction.

## OMP

Overlord Map Package
Under Construction.

## CLB

Content Library
Under Construction.

## BIK

Bink Video Format
Under Construction.

## PRP

Protected Resource Package
Under Construction.
For the technicals of the format, please refer to the [included docs](./technical_specs/PRP.md)

## RPK

Resource Package
Under Construction.
For the technicals of the format, please refer to the [included docs](./technical_specs/RPK.md)

## DTA

Under Construction.

## MAP

Texture Set Mapping File
Under Construction.

## TZF

Trusted ZLIB File
TZF files are a file type for compression, the only modifications you can do is compressing or decompressing, both of which the tool provided inside this repository can do for you.
For the technicals of the format, please refer to the [included docs](./technical_specs/TZF.md).

## OSG

Overlord Save Game

## OSI

Overlord Save Info

## PSP

## SPF

