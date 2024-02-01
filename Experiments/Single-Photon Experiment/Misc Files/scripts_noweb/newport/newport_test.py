import serial as ser

print('connecting')
connection = ser.Serial(port='COM1', baudrate=19200, xonxoff=True, timeout=1)
print('connected???')


def send(s):
    msg = '{}\n\r'.format(s)
    print('sending {!r}'.format(msg))
    return connection.write(bytes(msg, encoding='ascii'))


def recv():
    msg = connection.read_until(b'\r')
    print('received {!r}'.format(msg))
    return msg


try:
    while True:
        s = input('send: ').strip()
        if not s:
            recv()
            continue
        send(s)
        if s[-1] == '?':
            recv()
except KeyboardInterrupt:
    print('interrupted')


print('closing')
connection.close()
