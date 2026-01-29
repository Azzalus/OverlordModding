# Welcome to OverlordModding
[![OLM Logo]][./OLM_Logo.png]


# Basic File Formats
 - incomplete list
 - [OSI](#OSI)
 - [OSG](#OSG)
 - [TZF](#TZF)
 - [MAP](#MAP)
 - [DTA](#DTA)
 - [PRP](#PRP)
 - [OMP](#OMP)
 - [8LD](#8LD)
 - [MP3](#MP3)
 - [DDS](#DDS)
 - [DAT](#DAT)


# How to modify each file type

## DAT

Open in a hex editor of your choice, do NOT use regular notepad as these files use NULL characters rather than space characters, and some have sizes written in bytes.

## DDS

Open the file in Paint.net or alternatively if you want to use GIMP there is a DDS plugin you can use

## MP3

Audacity can export mp3's as long as you have the LAME encoder for it, and many other audio software suites allow exporting in MP3 format. FFMPEG can also convert audio files to/from MP3 when needed. Virtually every audio player in existence can play back these files.

## 8LD

Under Construction.

## OMP

Under Construction.

## CLB

Under Construction.

## BIK

Under Construction.

## PRP

Under Construction.

## DTA

Under Construction.

## MAP

Under Construction.

## TZF

TZF files are ZLIB deflate compressed files with the uncompressed filesize as the first 4 bytes, a 2 byte header, the compressed file, two magic words in little endian of uint32 0xDEADBEEF uint32 0xFEEDDEAF, a 4 byte inverted CRC32 hash of this file before the magic bytes, and a 4 byte termination sequence of 02 00 00 00
Since this file type is for compression, the only modifications you can do is compressing or decompressing, both of which the tool inside this repository can do.

## OSG

Overlord Save Game


## OSI

Overlord Save Info



