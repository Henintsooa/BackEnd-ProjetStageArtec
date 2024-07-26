<x-mail::message>
# Introduction

The body of your message.

<x-mail::button :url="'http://127.0.0.1:4200/reset-password-reset?token=' . $token">
Button Text
</x-mail::button>

Thanks,<br>
{{ config('app.name') }}
</x-mail::message>
