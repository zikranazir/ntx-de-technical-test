import httpx
from bs4 import BeautifulSoup
import polars as pl
import asyncio
import json
import logging
from tqdm.asyncio import tqdm_asyncio

# Configure logging
logging.basicConfig(filename='scraper.log', level=logging.INFO,
                    format='%(asctime)s %(levelname)s:%(message)s')

# Maximum number of pages for each level
max_pages = 10

# Output directory
output_dir = 'datasets/'

# Function to scrape a single page
async def scrape_page(client, level, page):
    url = f'https://www.fortiguard.com/encyclopedia?type=ips&risk={level}&page={page}'
    try:
        response = await client.get(url, timeout=10.0)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')
        data = []
        for item in soup.select('.row[onclick^="location.href"]'):
            link = 'https://www.fortiguard.com' + item['onclick'].split("'")[1]
            title = item.select_one('b').text.strip()
            data.append({'title': title, 'link': link})
        return data, None
    except httpx.HTTPStatusError as e:
        if e.response.status_code == 500:
            logging.error(f"Error 500 scraping level {level} page {page}: {e}")
        else:
            logging.error(f"HTTP error scraping level {level} page {page}: {e}")
        return None, page
    except Exception as e:
        logging.error(f"Error scraping level {level} page {page}: {e}")
        return None, page

# Main function to scrape all levels
async def scrape_all_levels():
    async with httpx.AsyncClient() as client:
        skipped_pages = {}
        for level in range(1, 6):
            tasks = [scrape_page(client, level, page) for page in range(1, max_pages + 1)]
            results = await tqdm_asyncio.gather(*tasks)
            
            all_data = []
            skipped = []
            for data, page in results:
                if data:
                    all_data.extend(data)
                if page:
                    skipped.append(page)
            
            # Save data to CSV
            df = pl.DataFrame(all_data)
            df.write_csv(f'{output_dir}level_{level}.csv')
            
            # Save skipped pages
            if skipped:
                skipped_pages[level] = skipped
        
        # Save skipped pages to JSON
        with open(f'{output_dir}skipped.json', 'w') as f:
            json.dump(skipped_pages, f, indent=4)

# Run the scraping script
if __name__ == "__main__":
    import os
    # Create the output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    asyncio.run(scrape_all_levels())
