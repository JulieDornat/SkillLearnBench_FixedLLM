import asyncio
import os
from openai import AsyncOpenAI


async def main():
    key = os.environ.get("GROQ_API_KEY", "")
    print("GROQ_API_KEY présente :", bool(key))
    print("Préfixe de la clé :", key[:6] + "..." if key else "(vide)")

    client = AsyncOpenAI(
        api_key=key,
        base_url="https://api.groq.com/openai/v1",
    )
    response = await client.chat.completions.create(
        model="llama-3.3-70b-versatile",
        messages=[{"role": "user", "content": "Réponds juste 'ok'"}],
    )
    print("Réponse :", response.choices[0].message.content)

asyncio.run(main())