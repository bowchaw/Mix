import subprocess
from functools import wraps
from bot import LOGGER, dispatcher
from bot import OWNER_ID
from telegram import ParseMode, Update
from telegram.ext import CallbackContext, CommandHandler
from telegram.ext.dispatcher import run_async

def dev_plus(func):
    
    @wraps(func)
    def is_dev_plus_func(update: Update, context: CallbackContext, *args,
                         **kwargs):
        bot = context.bot
        user = update.effective_user

        if user.id == OWNER_ID:
            return func(update, context, *args, **kwargs)
        elif not user:
            pass
        else:
            return func(update, context, *args, **kwargs)

    return is_dev_plus_func

@dev_plus
@run_async
def shell(update, context):
    message = update.effective_message
    cmd = message.text.split(' ', 1)
    if len(cmd) == 1:
        message.reply_text('𝐍𝐨 𝐜𝐨𝐦𝐦𝐚𝐧𝐝 𝐭𝐨 𝐞𝐱𝐞𝐜𝐮𝐭𝐞 𝐰𝐚𝐬 𝐠𝐢𝐯𝐞𝐧.')
        return
    cmd = cmd[1]
    process = subprocess.Popen(
        cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    stdout, stderr = process.communicate()
    reply = ''
    stderr = stderr.decode()
    stdout = stdout.decode()
    if stdout:
        reply += f"*Stdout*\n`{stdout}`\n"
        LOGGER.info(f"Shell - {cmd} - {stdout}")
    if stderr:
        reply += f"*Stderr*\n`{stderr}`\n"
        LOGGER.error(f"Shell - {cmd} - {stderr}")
    if len(reply) > 3000:
        with open('shell_output.txt', 'w') as file:
            file.write(reply)
        with open('shell_output.txt', 'rb') as doc:
            context.bot.send_document(
                document=doc,
                filename=doc.name,
                reply_to_message_id=message.message_id,
                chat_id=message.chat_id)
    else:
        message.reply_text(reply, parse_mode=ParseMode.MARKDOWN)

SHELL_HANDLER = CommandHandler(['sh', 'shell', 'r'], shell)
dispatcher.add_handler(SHELL_HANDLER)
