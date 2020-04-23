#https://www.poshud.com/Home
#Install-Module Selenium
#$Driver = Start-SeChrome
#Enter-SeUrl https://www.poshud.com -Driver $Driver

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

namespace Foo
{
    public class Bar
    {
        public static bool IsWindowsPlayingSound()
        {
            IMMDeviceEnumerator enumerator = (IMMDeviceEnumerator)(new MMDeviceEnumerator());
            IMMDevice speakers = enumerator.GetDefaultAudioEndpoint(EDataFlow.eRender, ERole.eMultimedia);
            IAudioMeterInformation meter = (IAudioMeterInformation)speakers.Activate(typeof(IAudioMeterInformation).GUID, 0, IntPtr.Zero);
            float value = meter.GetPeakValue();

            // this is a bit tricky. 0 is the official "no sound" value
            // but for example, if you open a video and plays/stops with it (w/o killing the app/window/stream),
            // the value will not be zero, but something really small (around 1E-09)
            // so, depending on your context, it is up to you to decide
            // if you want to test for 0 or for a small value
            return value > 1E-08;
        }

        [ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")]
        private class MMDeviceEnumerator
        {
        }

        private enum EDataFlow
        {
            eRender,
            eCapture,
            eAll,
        }

        private enum ERole
        {
            eConsole,
            eMultimedia,
            eCommunications,
        }

        [InterfaceType(ComInterfaceType.InterfaceIsIUnknown), Guid("A95664D2-9614-4F35-A746-DE8DB63617E6")]
        private interface IMMDeviceEnumerator
        {
            void NotNeeded();
            IMMDevice GetDefaultAudioEndpoint(EDataFlow dataFlow, ERole role);
            // the rest is not defined/needed
        }

        [InterfaceType(ComInterfaceType.InterfaceIsIUnknown), Guid("D666063F-1587-4E43-81F1-B948E807363F")]
        private interface IMMDevice
        {
            [return: MarshalAs(UnmanagedType.IUnknown)]
            object Activate([MarshalAs(UnmanagedType.LPStruct)] Guid iid, int dwClsCtx, IntPtr pActivationParams);
            // the rest is not defined/needed
        }

        [InterfaceType(ComInterfaceType.InterfaceIsIUnknown), Guid("C02216F6-8C67-4B5B-9D00-D008E73E0064")]
        private interface IAudioMeterInformation
        {
            float GetPeakValue();
            // the rest is not defined/needed
        }
    }
}
'@

$html = New-Object -ComObject "HTMLFile"
$html.IHTMLDocument2_write($(Get-Content $PSScriptRoot\index.html -raw))
$hrefs=$html.all.tags("A") | % href

$firstVideo=$true

foreach($href in $hrefs){
    if($firstVideo){
        $Driver = Start-SeChrome -StartURL $hrefs[0] -Maximized
        $StartingPage=Invoke-WebRequest $hrefs[0]
        Start-Sleep -Seconds 5        
    }
    $firstVideo=$false
    while ([Foo.Bar]::IsWindowsPlayingSound() -eq "True") {
        Start-Sleep -Seconds 5
    }
    Enter-SeUrl $href -Driver $Driver
    Start-Sleep -Seconds 5
}
#TODO add drive get url during each iteration to verify if web page has been changed.
$Driver.Close()
<#
$index=Invoke-WebRequest -Uri "http://localhost:8000/index.html" -UserAgent "Chrome"
$Driver = Start-SeChrome -StartURL 'localhost:8000'
$AllInputElements = Find-SeElement -Driver $Driver -TagName a
$Driver.Close()
function close {
    $href.Click()
        
}
ytp-bound-time-right





foreach($href in $AllInputElements){
    close
    exit
}
#>