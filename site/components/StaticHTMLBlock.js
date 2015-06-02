import React from 'react';
import CodeBlock from './CodeBlock';

export default class StaticHTMLBlock {
  static propTypes = {
    html: React.PropTypes.string.isRequired
  };

  render() {

    // Here goes a really hack-ish way to convert
    // areas separated by Markdown <hr>s into code tabs.

    if (!this.props.html) {
      return null;
    }

    const blocks = this.props.html.split('<hr/>');
    const elements = [];

    let es5Content = null;
    let es6Content = null;

    for (let i = 0; i < blocks.length; i++) {
      const content = blocks[i];

      switch (i % 3) {
      case 0:
        elements.push(
          <div key={i}
               style={{ width: '100%' }}
               dangerouslySetInnerHTML={{__html: content}} />
        );
        break;
      case 1:
        es5Content = content;
        break;
      case 2:
        es6Content = content;
        elements.push(
          <CodeBlock key={i}
                     es5={es5Content}
                     es6={es6Content}
          />
        );
        break;
      }
    }

    return (
      <div style={{ width: '100%' }}>
        {elements}
      </div>
    );
  }
}